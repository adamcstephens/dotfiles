{
  buildDunePackage,

  multipart_form,
  cohttp-lwt,
  multipart_form-lwt,
}:

buildDunePackage {
  pname = "multipart_form-cohttp-lwt";

  inherit (multipart_form) meta src version;

  propagatedBuildInputs = [
    cohttp-lwt
    multipart_form
    multipart_form-lwt
  ];
}
