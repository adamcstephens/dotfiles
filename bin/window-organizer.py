#!/usr/bin/env python3

import asyncio
import i3ipc.aio as i3ipc
import logging


def get_app_id_parents(con, app_id):
    parents = []

    for child in con.nodes:
        logging.debug(f"inspecting {child.name}")
        if child.app_id == app_id:
            return [con.id]

        parents += get_app_id_parents(child, app_id)

    return parents


async def main():
    logging.basicConfig(level=logging.INFO)
    sway = await i3ipc.Connection().connect()

    tree = await sway.get_tree()

    terminal_parents = get_app_id_parents(tree, "kitty")

    terminal_top = None

    for container in terminal_parents:
        c = tree.find_by_id(container)

        logging.debug(
            {
                "name": c.name,
                "window_role": c.window_role,
                "window_class": c.window_class,
                "app_id": c.app_id,
                "type": c.type,
                "layout": c.layout,
            }
        )

        if c.layout == "stacked":
            logging.info(f"Found terminal top {c.id}")
            terminal_top = c
            break

    #     if c.app_id == "kitty":
    #         print()

    # for desc in tree.descendants():
    #     parent = desc

    #     for c in desc.find_named(".*"):
    #         print(
    #             {
    #                 "name": c.name,
    #                 "window_role": c.window_role,
    #                 "window_class": c.window_class,
    #                 "app_id": c.app_id,
    #                 "type": c.type,
    #                 "layout": c.layout,
    #             }
    #         )

    #         if c.app_id == "kitty":
    #             print(parent.name)


asyncio.run(main())
