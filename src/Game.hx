@:expose
class Game {
    public static var title = 'Ping Pong';
    public static var author = 'Rodrigo Dornelles';
    public static var version = '1.0.0';
    public static var description = 'simple pong game write in haxe';

    public static function init(std:Dynamic, game:Dynamic):Void {
        game.score = 0;
        game.highscore = game.highscore == null ? 0 : game.highscore;
        game.player_size = game.height / 8;
        game.player_pos = game.height / 2 - game.player_size / 2;
        game.ball_pos_x = game.width / 2;
        game.ball_pos_y = game.height / 2;
        game.ball_spd_x = 0.3;
        game.ball_spd_y = 0.06;
        game.ball_size = 8;
    }

    public static function loop(std:Dynamic, game:Dynamic):Void {
        var player_dir = std.math.dir(std.key.press.down - std.key.press.up);
        game.player_pos = std.math.clamp(game.player_pos + (player_dir * 7), 0, game.height - game.player_size);
        game.ball_pos_x += game.ball_spd_x * game.dt;
        game.ball_pos_y += game.ball_spd_y * game.dt;

        if (game.ball_pos_x >= (game.width - game.ball_size)) {
            game.ball_spd_x = -std.math.abs(game.ball_spd_x);
        }
        if (game.ball_pos_y >= (game.height - game.ball_size)) {
            game.ball_spd_y = -std.math.abs(game.ball_spd_y);
        }
        if (game.ball_pos_y <= 0) {
            game.ball_spd_y = std.math.abs(game.ball_spd_y);
        }
        if (game.ball_pos_x <= 0) {
            if (std.math.clamp(game.ball_pos_y, game.player_pos, game.player_pos + game.player_size) == game.ball_pos_y) {
                var new_spd_y:Float = std.math.clamp(game.ball_spd_y + (game.player_pos % 10) - 5, -10, 10);
                game.ball_spd_y = (game.ball_spd_y == 0 && new_spd_y == 0) ? 20 : new_spd_y;
                game.ball_spd_y /= 16;
                game.ball_spd_x = std.math.abs(game.ball_spd_x) * 1.003;
                game.score++;
            } else {
                std.game.reset();
            }
        }
    }

    public static function draw(std:Dynamic, game:Dynamic):Void {
        std.draw.clear(std.color.black);
        std.draw.color(std.color.white);
        std.draw.rect(0, 4, game.player_pos, 8, game.player_size);
        std.draw.rect(0, game.ball_pos_x, game.ball_pos_y, game.ball_size, game.ball_size);
        std.draw.font('Tiresias', 32);
        std.draw.text(game.width / 4, 16, game.score);
        std.draw.text(game.width / 4 * 3, 16, game.highscore);
    }

    public static function exit(std:Dynamic, game:Dynamic):Void {
        game.highscore = std.math.max(game.highscore, game.score);
    }
}
