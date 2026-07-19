const std = @import("std");

pub fn query(comptime message: []const u8, args: anytype) void {
    printToStdout("[?] " ++ message, args);
}

pub fn log_stderr(comptime message: []const u8, args: anytype) void {
    printToStderr("[l] " ++ message ++ "\n", args);
}

// Informational `[i]` lines are launcher/maintenance housekeeping (the install
// path on first-invocation extraction, the uninstall flow) — NOT the wrapped
// program's own output. They go to STDERR so a machine-parsed STDOUT (e.g. a
// `<prog> version --json` invocation that triggers a first-run extraction)
// carries only the program's output. Interactive prompts (`query`, `[?]`) stay
// on STDOUT since they pair with a STDIN read.
pub fn info(comptime message: []const u8, args: anytype) void {
    printToStderr("[i] " ++ message ++ "\n", args);
}

pub fn warn(comptime message: []const u8, args: anytype) void {
    printToStderr("[w] " ++ message ++ "\n", args);
}

pub fn err(comptime message: []const u8, args: anytype) void {
    printToStderr("[!] " ++ message ++ "\n", args);
}

pub fn crit(comptime message: []const u8, args: anytype) void {
    printToStderr("[!!] " ++ message ++ "\n", args);
}

fn printToStdout(comptime message: []const u8, args: anytype) void {
    var stdout_buf: [64]u8 = undefined;
    var stdout_writer = std.fs.File.stdout().writer(&stdout_buf);
    const stdout = &stdout_writer.interface;

    stdout.print(message, args) catch {};
    stdout.flush() catch {};
}

fn printToStderr(comptime message: []const u8, args: anytype) void {
    var stderr_buf: [64]u8 = undefined;
    var stderr_writer = std.fs.File.stderr().writer(&stderr_buf);
    const stderr = &stderr_writer.interface;

    stderr.print(message, args) catch {};
    stderr.flush() catch {};
}
