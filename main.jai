#import "Input";
#import "Simp";
#import "Window_Creation";
#import "Basic";
#import "GetRect";

window: Window_Type;
close_window: bool;
last_time: float64;

main :: () {
    init_window();
    print("Hello\n");

    while !close_window {
        update_window_events();
        now := seconds_since_init();
        raw_delta: float64 = now - last_time;
        delta := cast(float32)raw_delta;
        last_time = now;
        update(delta);
        render();
        reset_temporary_storage();
    }
}

init_window :: () {
    window = create_window(1920, 1080, "Input");
    set_render_target(window);
}

update :: (delta: float32) {
}

render :: () {
    clear_render_target(0.3, 0.1, 0.4, 1);
    swap_buffers(window);
}

#load "input.jai";
