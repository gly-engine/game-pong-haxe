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
        game.ball_spd_x = 0.6;
        game.ball_spd_y = 0.12;
        game.ball_size = 8;
    }

    public static function loop(std:Dynamic, game:Dynamic):Void {
        game.player_pos = std.math.clamp(game.player_pos + (std.key.axis.y * 7), 0, game.height - game.player_size);
        game.ball_pos_x += game.ball_spd_x * std.delta;
        game.ball_pos_y += game.ball_spd_y * std.delta;

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
                std.app.reset();
            }
        }
    }

    public static function draw(std:Dynamic, game:Dynamic):Void {
        std.draw.clear(std.color.black);
        std.draw.color(std.color.white);
        std.draw.rect(0, 4, game.player_pos, 8, game.player_size);
        std.draw.rect(0, game.ball_pos_x, game.ball_pos_y, game.ball_size, game.ball_size);
        std.text.put(20, 1, game.score);
        std.text.put(60, 1, game.highscore);
    }

    public static function exit(std:Dynamic, game:Dynamic):Void {
        game.highscore = std.math.max(game.highscore, game.score);
    }
}
