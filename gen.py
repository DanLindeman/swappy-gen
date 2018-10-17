import fire
import subprocess
import re
import random
sprites = {
    'wall': '#',
    'green_player': 'G',
    'green_goal': '.',
    'green_door': 'g',
    'blue_player': 'B',
    'blue_goal': '*',
    'blue_door': 'b',
    'yellow_player': 'Y',
    'yellow_goal': '+',
    'yellow_door': 'y',
    'red_player': 'R',
    'red_goal': '-',
    'red_door': 'r',
    'floor': ' '
}

sprite_pattern = re.compile('\n*sprite\(\((\d{1,2}),(\d{1,2})\),(.*),(.*)\)\n*')
touch_pattern = re.compile('\n*touch\(\((\d{1,2}),(\d{1,2})\),(.*)\)\n*')

class Generator(object):
    """Shells out to prolog"""

    def generate(self, players=2, width=10, number_of_moves=4, show_paths=False):
        """pass args into prolog"""
        seed = random.randint(1,100)
        process = subprocess.Popen(['clingo', '-n', '1', '--rand-freq=1', f'--seed={seed}','generator/core.pl', 'generator/sim.pl', '-c', f'number_of_players={players}', '-c',f'width={width}', '-c', f'number_of_moves={number_of_moves}'], stdout=subprocess.PIPE)
        response, err = process.communicate()
        if not err:
            self.render(response.decode('UTF-8').rstrip(), width, show_paths)
        else:
            print(err)

    def render(self, raw_output, width, show_paths):
        """Parse the raw output and place sprites into square NxN grid where n=width"""
        no_newlines = re.sub("\n", " ", raw_output)
        output = no_newlines.split(" ")
        self.render_board(output, width)
        if show_paths:
            self.render_paths(output, width)

    def render_board(self, output, width):
        tiles = []
        for line in output:
            c = sprite_pattern.match(line)
            if c:
                x, y, sprite, color = c.groups()
                tiles.append((x, y, sprite, color))

        output = []
        for row in range(width):
            output.append([])
            for col in range(width):
                output[row].append(" ")

        for tile in tiles:
            if tile[3] != "none":
                sprite = f"{tile[3]}_{tile[2]}"
                output[int(tile[1])-1][int(tile[0])-1] = sprites[sprite]
            else:
                output[int(tile[1])-1][int(tile[0])-1] = sprites[tile[2]]

        for line in output:
            print("".join(line))

    def render_paths(self, output, width):
        print()
        print("********** Paths ************")
        paths = {'green': [], 'blue': [], 'red': [], 'yellow': []}
        for line in output:
            c = touch_pattern.match(line)
            if c:
                x, y, color = c.groups()
                paths[color].append((x,y))

        for color, path in paths.items():
            output = []
            print()
            print(color)
            for row in range(width):
                output.append([])
                for col in range(width):
                    output[row].append(" ")
            for touch in path:
                output[int(touch[0])-1][int(touch[1])-1] = color[0].lower()
            for line in output:
                print("".join(line))

if __name__ == "__main__":
    fire.Fire(Generator)