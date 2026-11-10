{
  config,
  inputs,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.dotfiles.apps.paseo;

  patches = [
    ./omp-custom-message-history.patch
    (pkgs.fetchpatch {
      url = "https://github.com/getpaseo/paseo/commit/040dc103f6b3e21d96b8d35c248f8ffd39d61473.patch";
      hash = "sha256-apvlzVMww0vYk1Qv3DQy2KkHQx2vsGGNYQ3vnGqADO0=";
    })
  ];

  package =
    inputs.nixos-unstable-small.legacyPackages.${pkgs.stdenv.hostPlatform.system}.paseo.overrideAttrs
      (old: {
        doCheck = false;
        patches = (old.patches or [ ]) ++ patches;
        postInstall = ''
          wrapProgram "$out/bin/paseo" \
            --run 'export PASEO_STATE_HOME="''${PASEO_STATE_HOME:-''${HOME}/.local/state/paseo}"'
        '';
      });

  roles = {
    director = {
      id = "agent_profile_engineering_director";
      name = "Engineering Director";
      icon = "users";
      notes = ''
        Use to coordinate delivery across engineers, with the System Architect as a peer.
        When launching, instruct the Director to own execution planning, staffing, delegation,
        dependencies, progress, integration, and verification.  Ask it to coordinate through
        Paseo tools and profiles and delegate product implementation to engineers, not write
        product code.  Require clear assignment ownership, scope, dependencies, and acceptance
        criteria.  Instruct it to consult the Architect for consequential design decisions,
        not every task; the Architect owns technical direction, design tradeoffs, and
        architectural review.  Ask it to resolve execution issues and surface unresolved
        technical disagreements to the user rather than override the Architect.  Instruct it
        to use proportional staffing, avoid assembling a team for simple requests, and obtain
        integration and verification evidence before reporting completion.
      '';
    };

    architect = {
      id = "agent_profile_system_architect";
      name = "System Architect";
      icon = "layers";
      color = "sky";
      notes = ''
        Use for technical direction, design tradeoffs, and architectural review, with the
        Engineering Director as a peer responsible for execution and coordination.
        When launching, instruct the Architect to read code and understand the current
        architecture before proposing system-level changes.  Ask it to use Paseo tools to
        consult and coordinate with the team, but not write product code; delegate
        implementation to engineers.  Request design opinion and feedback before
        implementation when warranted by risk, not as a mandatory gate for every task.
      '';
    };

    staff = {
      id = "agent_profile_staff_engineer";
      name = "Staff Engineer";
      icon = "hammer";
      notes = ''
        taff Engineer, full-stack with deep knowledge of software engineering.  Works with the
        System Architect to plan and implement features, end-to-end.  Always give a clear plan of
        attack, implementation overview, key design decisions, architecture, and ask to
        implement.  Ask to keep comms open, report back, ask questions if not clear.  Use for
        every-day, low-risk work; leave challenging work to Principal Engineer.
      '';
    };

    principal = {
      id = "agent_profile_principal_engineer";
      name = "Principal Engineer";
      icon = "code";
      color = "violet";
      notes = ''
        Principal Engineer, full-stack that is comfortable working at all layers of the
        stack.  Applies rigor to the implementation and focuses not only on solving the problem, but
        also thinking deeply about modularity, scalability, security, and clean code.  Uses interfaces
        and abstractions where necessary to decouple contracts from implementation.  YAGNI does not
        apply to things that make code more malleable and extensible since this gives degrees of
        freedom. Thinks deeply about testability and how to properly test code without creating noise;
        over doing testing with low signal tests slows everyone down.  Works with a team of Staff
        Engineers when work can be delegated, coordinated, and performed in parallel.  Ask to
        implement the agreed upon design; ask questions if lack of clarity.  Ask to provide feedback
        if it sees a gap in the design.  Focuses on implementation for HARD, challenging work.  Do not
        hand easy, low-risk work to this engineer.
      '';
    };

    junior = {
      id = "agent_profile_junior_engineer";
      name = "Junior Engineer";
      icon = "hammer";
      notes = "Use for lightweight work, rote refactors, and simple, low-risk tasks.";
    };
  };

  claudeRole =
    role:
    role
    // {
      id = "${role.id}_claude";
      name = "${role.name} (Claude)";
      provider = "claude";
    };
in
{
  imports = [
    ./module.nix
  ];

  options.dotfiles.apps.paseo.profiles = {
    claude = lib.mkEnableOption "claude profiles";
    omp = lib.mkOption {
      type = lib.types.bool;
      description = "omp profiles";
      default = true;
    };
  };

  config = {
    home.packages = lib.optionals config.dotfiles.gui.enable [
      (package.desktop.overrideAttrs (old: {
        patches = (old.patches or [ ]) ++ patches;
      }))
    ];

    services.paseo = {
      enable = true;
      inherit package;

      settings = {
        app.baseUrl = "https://paseo.junco.dev";

        agents = {
          providers = {
            antigravity.enabled = false;
            claude.enabled = true;
            codex.enabled = true;
            copilot.enabled = false;
            muse.enabled = false;
            omp.enabled = true;
            opencode.enabled = false;
            pi.enabled = false;
          };

          metadataGeneration.providers = [
            {
              provider = "omp";
              model = "openai-codex/gpt-6-luna";
            }
          ];
        };

        daemon = {
          relay = {
            enabled = true;
            endpoint = "paseo-relay.junco.dev:443";
            useTls = true;
          };

          mcp = {
            enabled = true;
            injectIntoAgents = true;
          };

          appendSystemPrompt = ''
            <operating_environment>
            You are operating in a Paseo agent harness; `paseo-*` skills and `paseo` CLI are available (as
            needed to explore the workspace, other agents collaborating)

            You MUST always use paseo agents instead of builtin harness subagents, using ONLY paseo agent profiles.
            </operating_environment>

            - Use `paseo-*` skills to coordinate with the team
            - When starting a new agent, always let them know their identity, specific role, ownership of
            responsibilities, and how they can contribute; set clear expectations at initialization.
            - Profile notes are briefing guidance, not automatically injected role instructions.
            Read the selected profile's notes and include the applicable role responsibilities,
            constraints, and coordination expectations in the new agent's initialization prompt.
            - Use XML *when initializing new agents*: <role>(sub-agent role, identity; them)</role>,
            <lead_role>("self", you; identity + role)</lead_role>, <objective>(sub-agent's goal)</objective>,
            <instruction_details>(existing context, inputs, info, details of task, tips, references,
            etc.)</instruction_details>, <scope>(what do vs what not do)</scope>, <team>(other sub-agents,
            team info, responsibilities, roles; as needed)</team>, <gates>(any specific exit gates, checks;
            only as relevant (optional))</gates><comms>(specific instructions for comms, what to report, when
            to report, format of report, etc.; optional as needed)</comms>
            - Use a "risk-based" approach when assembling team to work on a task; assign work that has higher
            risk to more senior engineers
            - For technical design work/architecture, ask Member of Technical Staff and/or System Architect
            for inputs, other ideas, expand and explore the solution space before proceeding
            when available
            - Create workspaces (worktrees) only when work benefits from isolated branches (parallel,
            overlapping work).  Coordinate edits otherwise.  Worktrees add some complexity.
          '';

          agentProfiles =
            lib.optionals cfg.profiles.omp [
              (
                roles.director
                // {
                  provider = "omp";
                  model = "openai-codex/gpt-6-astra";
                  modeId = "full";
                  thinkingOptionId = "medium";
                }
              )
              (
                roles.architect
                // {
                  provider = "omp";
                  model = "openai-codex/gpt-6-astra";
                  modeId = "full";
                  thinkingOptionId = "high";
                }
              )
              (
                roles.staff
                // {
                  provider = "omp";
                  model = "openai-codex/gpt-6.1-sol";
                  modeId = "full";
                  thinkingOptionId = "low";
                }
              )
              (
                roles.principal
                // {
                  provider = "omp";
                  model = "openai-codex/gpt-6-astra";
                  modeId = "full";
                  thinkingOptionId = "medium";
                }
              )
              (
                roles.junior
                // {
                  provider = "omp";
                  model = "openai-codex/gpt-6.1-terra";
                  modeId = "full";
                  thinkingOptionId = "medium";
                }
              )
            ]
            ++ lib.optionals cfg.profiles.claude [
              (
                claudeRole roles.architect
                // {
                  model = "claude-fable-5-1";
                  modeId = "plan";
                  thinkingOptionId = "high";
                }
              )
              (
                claudeRole roles.staff
                // {
                  model = "claude-opus-5-5";
                  modeId = "auto";
                  thinkingOptionId = "low";
                }
              )
              (
                claudeRole roles.principal
                // {
                  model = "claude-fable-5-1";
                  modeId = "auto";
                  thinkingOptionId = "low";
                }
              )
              (
                claudeRole roles.junior
                // {
                  model = "claude-sonnet-5-5";
                  modeId = "auto";
                  thinkingOptionId = "medium";
                }
              )
            ];
        };

        features = {
          dictation.enabled = false;
          voiceMode.enabled = false;
        };

        pluginsEnabled = true;
      };
    };

    systemd.user.services = lib.mkIf pkgs.stdenv.hostPlatform.isLinux {
      paseo.Service.EnvironmentFile = "${config.services.paseo.dataDir}/pass.env";

      paseo-pwgen = {
        Unit = {
          Before = [ "paseo.service" ];
        };
        Install = {
          WantedBy = [ "default.target" ];
          RequiredBy = [ "paseo.service" ];
        };

        Service = {
          Environment = [
            "PASEO_HOME=${config.services.paseo.environment.PASEO_HOME or config.services.paseo.dataDir}"
          ];
          Type = "oneshot";
          RemainAfterExit = true;
          ExecStart =
            pkgs.writeShellApplication {
              name = "paseo-pwgen";
              runtimeInputs = [
                pkgs.coreutils
                pkgs.pwgen
              ];
              text = ''
                mkdir -p "$PASEO_HOME"
                if [ ! -e "$PASEO_HOME/pass.env" ]; then
                  echo "PASEO_PASSWORD=$(pwgen -sc1 32)" > "$PASEO_HOME/pass.env"
                fi
              '';
            }
            |> lib.getExe;
        };
      };
    };
  };
}
