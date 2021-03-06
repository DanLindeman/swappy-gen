import fire
import subprocess
import re
import random
import time

sprites = {
    'wall': '#',
    'green_player': 'G',
    'green_goal': '.',
    'green_door': 'g',
    'blue_player': 'B',
    'blue_goal': '*',
    'blue_door': 'b',
    'yellow_player': 'Y',
    'yellow_goal': '-',
    'yellow_door': 'y',
    'red_player': 'R',
    'red_goal': '+',
    'red_door': 'r',
    'floor': ' '
}

SPRITE_PATTERN = re.compile(r'\n*sprite\(\((\d{1,2}),(\d{1,2})\),(.*),(.*)\)\n*')
TOUCH_PATTERN = re.compile(r'\n*touch\(\((\d{1,2}),(\d{1,2})\),(.*)\)\n*')

class Generator(object):
    """Shells out to prolog"""

    def generate(self, players=3, width=8, number_of_moves=5, show_paths=False):
        """pass args into prolog"""
        seed = random.randint(1,100)
        start_time = time.time()
        with open("seed_log.txt", "w") as seed_log:
            seed_log.write(f"seed={seed}")
        command_list = ['clingo', '-n', '1', '--rand-freq=1', f'--seed={seed}','generator/core.pl', 'generator/sim.pl', 'generator/style.pl', '-c', f'number_of_players={players}', '-c',f'width={width}', '-c', f'number_of_moves={number_of_moves}']
        print(f"Run with \n{' '.join(command_list)}")
        process = subprocess.Popen(['clingo', 
                                        '-n', 
                                        '1', 
                                        '--rand-freq=1', 
                                        f'--seed={seed}',
                                        'generator/core.pl', 
                                        'generator/sim.pl', 
                                        'generator/style.pl', 
                                        '-c', f'number_of_players={players}',
                                        '-c',f'width={width}',
                                        '-c', f'number_of_moves={number_of_moves}'
                                    ], stdout=subprocess.PIPE)
        response, err = process.communicate()
        if not err:
            self.render(response.decode('UTF-8').rstrip(), width, show_paths)
        else:
            print(err)
        elapsed_time = time.time() - start_time
        print(f'\nLevel Generation done in: {time.strftime("%H:%M:%S", time.gmtime(elapsed_time))}')

    def run_with_preset_level(self, show_paths=False, level_num="01"):
        """pass args into prolog"""
        seed = random.randint(1,100)
        with open("seed_log.txt", "w") as seed_log:
            seed_log.write(f"seed={seed}")
        width, players = self.get_params_from_input_file(level_num)
        process = subprocess.Popen(['clingo', '-n', '1', '--rand-freq=1', f'--seed={seed}', f'graph/output/{level_num}.pl','generator/core.pl','generator/sim.pl', '-c', f'number_of_players={players}', '-c',f'width={width}'], stdout=subprocess.PIPE)
        response, err = process.communicate()
        if not err:
            self.render(response.decode('UTF-8').rstrip(), width, show_paths)
        else:
            print(err)

    def get_params_from_input_file(self, level_num):
        with open(f'graph/output/{level_num}.pl') as level:
            max_x = 1
            max_y = 1
            players = 0
            for line in level.readlines():
                c = SPRITE_PATTERN.match(line)
                x, y, sprite, _ = c.groups()
                if int(x) > max_x: max_x = int(x)
                if int(y) > max_y: max_y = int(y)
                if sprite == 'player':
                    players += 1
        width = max(max_x, max_y)
        return width, players

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
            c = SPRITE_PATTERN.match(line)
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
            c = TOUCH_PATTERN.match(line)
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
                output[int(touch[1])-1][int(touch[0])-1] = color[0].lower()
            for line in output:
                print("".join(line))

if __name__ == "__main__":
    fire.Fire(Generator)