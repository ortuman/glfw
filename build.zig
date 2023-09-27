const std = @import("std");

pub fn build(b: *std.Build) void {
    const target = b.standardTargetOptions(.{});
    const optimize = b.standardOptimizeOption(.{});

    const lib = b.addStaticLibrary(.{
        .name = "glfw",
        .target = target,
        .optimize = optimize,
    });
    const t = lib.target_info.target;

    lib.addCSourceFiles(&generic_src_files, &.{});
    lib.linkLibC();

    switch (t.os.tag) {
        .macos => {
            lib.defineCMacro("_GLFW_COCOA", "1");
            lib.addCSourceFiles(&macos_src_files, &.{});
            lib.linkFramework("Cocoa");
            lib.linkFramework("IOKit");
            lib.linkFramework("CoreFoundation");
        },
        else => {
            std.debug.panic("unexpected OS tag: {}", .{t.os.tag});
        },
    }
    lib.installHeadersDirectory("include/GLFW", "GLFW");
    b.installArtifact(lib);
}

const generic_src_files = [_][]const u8{
    "src/context.c",
    "src/init.c",
    "src/input.c",
    "src/monitor.c",
    "src/platform.c",
    "src/vulkan.c",
    "src/window.c",
    "src/egl_context.c",
    "src/osmesa_context.c",
    "src/null_init.c",
    "src/null_monitor.c",
    "src/null_window.c",
    "src/null_joystick.c",
};

const macos_src_files = [_][]const u8{
    "src/cocoa_init.m",
    "src/cocoa_joystick.m",
    "src/cocoa_monitor.m",
    "src/cocoa_window.m",
    "src/nsgl_context.m",
    "src/cocoa_time.c",
    "src/posix_thread.c",
    "src/posix_module.c",
};
