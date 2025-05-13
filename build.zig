const std = @import("std");

pub fn build(b: *std.Build) void {
    const target = b.standardTargetOptions(.{});
    const optimize = b.standardOptimizeOption(.{});

    // Create Nuklear static library
    const nuklear_lib = b.addStaticLibrary(.{
        .name = "nuklear",
        .target = target,
        .optimize = optimize,
    });
    nuklear_lib.addCSourceFile(.{
        .file = b.path("libs/nuklear/nuklear_wrapper.c"),
        .flags = &[_][]const u8{"-std=c89"},
    });
    nuklear_lib.linkLibC();

    // Create modules
    const atak = b.createModule(.{
        .root_source_file = b.path("../atak/src/atak.zig"),
        .target = target,
        .optimize = optimize,
    });

    const nutak = b.createModule(.{
        .root_source_file = b.path("src/nutak.zig"),
        .target = target,
        .optimize = optimize,
    });
    nutak.addImport("atak", atak);

    // Main library - FIXED: Remove target/optimize here
    const lib = b.addStaticLibrary(.{
        .name = "atak",
        .root_module = atak, // Module already contains target/optimize
    });
    lib.addIncludePath(b.path("libs/nuklear"));
    lib.linkLibrary(nuklear_lib);
    b.installArtifact(lib);

    // Test setup
    const lib_unit_tests = b.addTest(.{
        .root_module = atak,
    });
    const run_lib_unit_tests = b.addRunArtifact(lib_unit_tests);

    const exe_unit_tests = b.addTest(.{
        .root_module = nutak,
    });
    const run_exe_unit_tests = b.addRunArtifact(exe_unit_tests);

    const test_step = b.step("test", "Run unit tests");
    test_step.dependOn(&run_lib_unit_tests.step);
    test_step.dependOn(&run_exe_unit_tests.step);
}
