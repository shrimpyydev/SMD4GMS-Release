function parse_smd_node_line(_line)
{
    var line = string_trim(_line);

    // Find quoted name
    var q1 = string_pos(chr(34), line);
    var q2 = string_last_pos(chr(34), line);

    if (q1 == 0 || q2 == 0)
    {
        show_debug_message("Invalid SMD node line (missing quotes): " + line);
        return undefined;
    }

    // Extract name (between quotes)
    var name = string_copy(
        line,
        q1 + 1,
        q2 - q1 - 1
    );

    // Extract parent index (after closing quote)
    var parent_str = string_trim(
        string_copy(line, q2 + 1, string_length(line))
    );

    var parent_index = real(parent_str);

    return [ name, parent_index ];
}
