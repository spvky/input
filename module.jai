Input_Buffer :: struct($ACTION: Type)
#modify {
    info := (cast(*Type_Info_Enum)ACTION);
    if info.type != .ENUM then return false,
                                      "Action Type must be an enum";
    return true;
} {
    MAP_SIZE :: #run -> int {
        info := (cast(*Type_Info_Enum)ACTION);
        return info.values.count;
    }
    buffer_length: float32 = 0.25;
    map: [MAP_SIZE]Key_Code;
    buffered: [MAP_SIZE]float32;
    held: [MAP_SIZE]bool;
    released: [MAP_SIZE]float32;
}

register_input :: (ib: *Input_Buffer($T), action: T, key_code: Key_Code) {
    ib.map[action] = xx key_code;
}

// Reads over `Input.events_this_frame` to detect inputs and progresses Input_Buffer by delta
update_buffer :: (ib: *Input_Buffer($T), delta: float32) {
    for i: 0..ib.MAP_SIZE - 1 {
        ib.buffered[i] -= delta;
        if ib.buffered[i] < 0 {
            if ib.held[i] {
                ib.buffered[i] = 0;
            } else {
                ib.buffered[i] = -1;
            }
        }
        ib.released[i] -= delta;
        if ib.released[i] < 0 {
            ib.released[i] = -1;
        }
    }

    for event: events_this_frame {
        parse_event(ib, event);
    }
}

is_action_buffered :: (ib: *Input_Buffer($T), action: T) -> bool {
    return ib.buffered[action] > 0;
}

consume_action :: (ib: *Input_Buffer($T), action: T) {
    ib.buffered[action] = 0;
}

#scope_module
parse_event :: (ib: *Input_Buffer($T), e: Event) {
    for i: 0..ib.MAP_SIZE - 1 {
        if ib.map[i] == xx e.key_code {
            if e.key_pressed {
                // Pressed Key
                ib.held[i] = true;
                if ib.buffered[i] <= -1 {
                    ib.buffered[i] = ib.buffer_length;
                }
            } else {
                // Released Key
                ib.held[i] = false;
                if ib.released[i] <= -1 {
                    ib.released[i] = ib.buffer_length;
                }
                ib.buffered[i] = -1;
            }
        }
    }
}
