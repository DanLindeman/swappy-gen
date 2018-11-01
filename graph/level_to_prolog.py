"""Reads files in the level directory, Produces prolog sprite maps for each"""
from  os import walk, listdir

TILE_TYPES = {
    "#": "none_wall",
    " ": "",
    "G": "green_player",
    "g": "green_door",
    ".": "green_goal",
    "B": "blue_player",
    "b": "blue_door",
    "*": "blue_goal",
    "R": "red_player",
    "r": "red_door",
    "+": "red_goal",
    "Y": "yellow_player",
    "y": "yellow_door",
    "-": "yellow_goal",
}

class LevelReader:

    def __init__(self):
        self.level_files = self.get_level_files()
        self.make_levels()


    def get_level_files(self):
        levels = []
        for (_, _, levels) in walk('./graph/levels'):
            levels.reverse()
            levels = [f'./graph/levels/{level}' for level in levels]
        return levels

    def make_levels(self):
        for level_file in self.level_files:
            with open(level_file) as level:
                level_number = level_file.split("/")[-1].split(".")[0]
                print(f"level_number {level_number}")
                lines = level.readlines()
                output_lines = []
                for row_index, line in enumerate(lines):
                    for colum_index, tile in enumerate(line.strip()):
                        if tile != " ":
                            color, tile_type = TILE_TYPES[tile].split("_")
                            output_lines.append(f"sprite(({colum_index + 1},{row_index + 1}),{tile_type},{color}).")
                for line in output_lines:
                    with open(f"./graph/output/{level_number}.pl", "a") as prolog_level:
                        prolog_level.write(line +'\n')

if __name__ == "__main__":
    lr = LevelReader()