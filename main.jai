window: Window_Type;
close_window: bool;
last_time: float64;

Action :: enum {
    Jump;
    Kick;
    Roll;
    Dive;
    Shoot;
}

buffer: Input_Buffer(Action);

main :: () {
    init_window();

    raw_ti := type_info(Action);
    ti := cast(*Type_Info_Enum)raw_ti;
    for ti.names {
        print("%\n", it);
    }

    register_input(*buffer, .Jump, .SPACEBAR);
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
    update_buffer(*buffer, delta);
    if is_action_buffered(*buffer, .Jump) {
        consume_action(*buffer, .Jump);
        print("JUMPED!!\n");
    }
}

render :: () {
    clear_render_target(0.3, 0.1, 0.4, 1);
    swap_buffers(window);
}

draw_ui :: () {
    //  ti := cast(*Type_Info_Enum)type_info(Action);
    for i: 0..buffer.MAP_SIZE - 1 {
        name := tprint("%", cast(i)Action);
        map := buffer.map[i];
        buffer_value := buffer.buffered[i];
        held := buffer.held[i];
        released := buffer.released[i];
    }
}

#import "Input";
#import "Simp";
#import "Window_Creation";
#import "Basic";
#import "GetRect";

#load "input.jai";
