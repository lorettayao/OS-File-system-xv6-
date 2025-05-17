from gradelib import *
import re

r = Runner()


### Problem I ###
@test(5, "mp4 problem I public testcase 0")
def test_mp4_1_0():
    # basic commands functionality check
    r.run_qemu(
        shell_script(
            [
                "gen 0",
                "ls test1",
                "ls test1/a",
                "chmod -rw test1/a",
                "chmod -rw test1/b",
                "ls test1/d",
                "chmod -r test1",
                "ls test1",
                "mp4_1 0",
            ]
        )
    )
    r.match(
        "$ gen 0",
        "$ ls test1",
        ".              1 22 96 rw",
        "..             1 1 1024 rw",
        "a              2 23 3 rw",
        "b              2 24 3 rw",
        "c              2 25 3 rw",
        "d              1 26 48 rw",
        "$ ls test1/a",
        "a              2 23 3 rw",
        "$ chmod -rw test1/a",
        "$ chmod -rw test1/b",
        "$ ls test1/d",
        ".              1 26 48 rw",
        "..             1 22 96 rw",
        "a              2 27 3 rw",
        "$ chmod -r test1",
        "$ ls test1",
        "ls: cannot open test1",
        "$ mp4_1 0",
        "open test1 failed",
        "open test1/a failed",
        "open test1/d failed",
    )


@test(5, "mp4 problem I public testcase 1")
def test_mp4_1_1():
    # simple symln
    r.run_qemu(
        shell_script(
            [
                "gen 1",
                "chmod +-rw test2/d1/f1",
                "chmod -R +w test2/d100",
                "chmod -R -r test2/d2",
                "ls test2",
                "ls test2/d2",
                "ls test2/d1/f1",
                "symln test2 test2_fake",
                "symln test1 test2_fake",
                "ls test2_fake",
                "ls test2_fake/d2",
                "ls test2_fake/d100",
                "mp4_1 1",
            ]
        )
    )
    r.match(
        *(
            """\
$ gen 1
$ chmod +-rw test2/d1/f1
Usage: chmod [-R] (+|-)(r|w|rw|wr) file_name|dir_name
$ chmod -R +w test2/d100
chmod: cannot chmod test2/d100
$ chmod -R -r test2/d2
$ ls test2
.              1 23 80 rw
..             1 1 1024 rw
d1             1 24 48 rw
d2             1 25 48 -w
d3             1 26 48 rw
$ ls test2/d2
ls: cannot open test2/d2
$ ls test2/d1/f1
f1             2 27 3 rw
$ symln test2 test2_fake
$ symln test1 test2_fake
symlink test1 test2_fake: failed
$ ls test2_fake
.              1 23 80 rw
..             1 1 1024 rw
d1             1 24 48 rw
d2             1 25 48 -w
d3             1 26 48 rw
$ ls test2_fake/d2
ls: cannot open test2_fake/d2
$ ls test2_fake/d100
ls: cannot open test2_fake/d100
$ mp4_1 1
open test2_fake/d2/f2 failed
read test2_fake/d1/f1 failed
type of test2_fake/d1/f1 is 2""".split(
                "\n"
            )
        )
    )


@test(5, "mp4 problem I public testcase 2")
def test_mp4_1_2():
    r.run_qemu(
        shell_script(
            [
                "gen 2",
                "symln test3/d1 test3/d1ln_1",
                "symln test3/d1ln_1 test3/d1ln_2",
                "symln test3/d1ln_2 test3/d1ln_3",
                "symln test3/d1ln_3 test3/d1ln_4",
                "chmod -R +rw test3/d1ln_4",
                "chmod -R -rw test3/d1ln_4",
                "chmod +r test3/d1/D/F",
                "symln test3/d1/D/F test3/Fln",
                "ls test3/Fln",
                "chmod +r test3/d1",
                "ls test3",
                "ls test3/d1ln_4",
                "mp4_1 2",
            ]
        )
    )
    r.match(
        *(
            """\
$ gen 2
$ symln test3/d1 test3/d1ln_1
$ symln test3/d1ln_1 test3/d1ln_2
$ symln test3/d1ln_2 test3/d1ln_3
$ symln test3/d1ln_3 test3/d1ln_4
$ chmod -R +rw test3/d1ln_4
$ chmod -R -rw test3/d1ln_4
$ chmod +r test3/d1/D/F
chmod: cannot chmod test3/d1/D/F
$ symln test3/d1/D/F test3/Fln
$ ls test3/Fln
ls: cannot open test3/Fln
$ chmod +r test3/d1
$ ls test3
.              1 23 128 rw
..             1 1 1024 rw
d1             1 24 96 r-
d1ln_1         4 30 13 rw
d1ln_2         4 31 17 rw
d1ln_3         4 32 17 rw
d1ln_4         4 33 17 rw
Fln            4 34 17 rw
$ ls test3/d1ln_4
.              1 24 96 r-
..             1 23 128 rw
D              1 25 48 --
f1             2 26 3 --
f2             2 27 3 --
f3             2 28 3 --
$ mp4_1 2
type of test3/d1ln_4 is 4
type of the target file test3/d1ln_4 pointing to is 1
open test3/Fln (1) failed
type of test3/Fln is 4""".split(
                "\n"
            )
        )
    )


@test(5, "mp4 problem I public testcase 3")
def test_mp4_1_3():
    # special case
    r.run_qemu(
        shell_script(
            [
                "gen 3",
                "symln test4/dirX test4/dirXln1",
                "symln test4/dirX test4/dirXln2",
                "symln test4/dirX/a test4/aln1",
                "chmod -R -rw test4/dirXln1",
                "chmod -R -rw test4/dirXln2",
                "symln test4/dirX/a test4/aln2",
                "ls test4/aln1",
                "ls test4/aln2",
                "ls test4",
                "ls test4/dirX",
                "ls test4/dirXln1/c",
                "ls test4/dirXln2",
                "chmod -R +rw test4/dirX",
                "ls test4",
                "ls test4/aln1",
                "ls test4/dirXln1",
                "mp4_1 3",
            ]
        )
    )
    r.match(
        *(
            """\
$ gen 3
$ symln test4/dirX test4/dirXln1
$ symln test4/dirX test4/dirXln2
$ symln test4/dirX/a test4/aln1
$ chmod -R -rw test4/dirXln1
$ chmod -R -rw test4/dirXln2
chmod: cannot chmod test4/dirXln2
$ symln test4/dirX/a test4/aln2
$ ls test4/aln1
ls: cannot open test4/aln1
$ ls test4/aln2
ls: cannot open test4/aln2
$ ls test4
.              1 23 112 rw
..             1 1 1024 rw
dirX           1 24 80 --
dirXln1        4 28 15 rw
dirXln2        4 29 15 rw
aln1           4 30 17 rw
aln2           4 31 17 rw
$ ls test4/dirX
ls: cannot open test4/dirX
$ ls test4/dirXln1/c
ls: cannot open test4/dirXln1/c
$ ls test4/dirXln2
ls: cannot open test4/dirXln2
$ chmod -R +rw test4/dirX
$ ls test4
.              1 23 112 rw
..             1 1 1024 rw
dirX           1 24 80 rw
dirXln1        4 28 15 rw
dirXln2        4 29 15 rw
aln1           4 30 17 rw
aln2           4 31 17 rw
$ ls test4/aln1
aln1           4 30 17 rw
$ ls test4/dirXln1
.              1 24 80 rw
..             1 23 112 rw
a              2 25 3 rw
b              2 26 3 rw
c              2 27 3 rw
$ mp4_1 3
hello os2025""".split(
                "\n"
            )
        )
    )


### Problem II ###
TEST_FILE_LBN_IN_C = 1


def get_pbn0_for_file_lbn(runner_instance, file_lbn_to_find):
    """
    Runs the C test program (scenario 0) to extract the PBN0
    that corresponds to the given file_lbn_to_find.
    """
    print(
        "PYTHON_INFO: Running setup to get PBN0 for File LBN {}.".format(
            file_lbn_to_find
        )
    )
    runner_instance.run_qemu(
        shell_script(["echo .", "mp4_2_write_failure_test 0"]), timeout=300
    )

    qemu_output = runner_instance.qemu.output

    pattern_string = (
        r"TEST_DRIVER_INFO: File LBN {} is mapped to Disk LBN \(PBN0\) (\d+)\.".format(
            file_lbn_to_find
        )
    )
    match_obj = re.search(pattern_string, qemu_output)

    if match_obj:
        pbn0 = int(match_obj.group(1))
        print(
            "PYTHON_INFO: Captured PBN0 = {} for File LBN {}.".format(
                pbn0, file_lbn_to_find
            )
        )
        return pbn0
    else:
        print(
            "PYTHON_ERROR: Could not find PBN0 mapping for File LBN {} in output!".format(
                file_lbn_to_find
            )
        )
        print(
            "------- QEMU Output for PBN0 Capture (from get_pbn0_for_file_lbn): -------"
        )
        print(qemu_output)
        print(
            "--------------------------------------------------------------------------"
        )
        runner_instance.fail_test(
            "PBN0 mapping not found for File LBN {}".format(file_lbn_to_find)
        )
        return None


# --- Test Cases ---


@test(
    0,
    "mp4 problem II public testcase: Bwrite Test: Normal Write (No specific kernel message check)",
)
def test_normal_write():
    pbn0_val = get_pbn0_for_file_lbn(r, TEST_FILE_LBN_IN_C)
    if pbn0_val is None:
        return
    pbn1_val = pbn0_val + 2048

    r.run_qemu(shell_script(["echo .", "mp4_2_write_failure_test 0"]))
    r.match_substrings_ordered(
        "TEST_DRIVER: Scenario 0 - Normal Write.",
        "BW_DIAG: PBN0={}, PBN1={}, sim_disk_fail=-1, sim_pbn0_block_fail=0".format(
            pbn0_val, pbn1_val
        ),
        # We are not strictly matching ATTEMPT messages here as per user request,
        # but we expect the C program to finish.
        "TEST_DRIVER: Scenario 0 finished.",
    )


@test(
    10, "mp4 problem II public testcase: Bwrite Test: Disk 0 Failure (Checks SKIP_PBN0)"
)
def test_disk0_failure():
    pbn0_val = get_pbn0_for_file_lbn(r, TEST_FILE_LBN_IN_C)
    if pbn0_val is None:
        return
    pbn1_val = pbn0_val + 2048

    r.run_qemu(
        shell_script(["echo .", "mp4_2_write_failure_test 1"])
    )  # Trigger Scenario 1
    r.match_substrings_ordered(
        "TEST_DRIVER: Scenario 1 - Simulating Disk 0 Failure.",
        "BW_DIAG: PBN0={}, PBN1={}, sim_disk_fail=0, sim_pbn0_block_fail=0".format(
            pbn0_val, pbn1_val
        ),
        "BW_ACTION: SKIP_PBN0 (PBN {}) due to simulated Disk 0 failure.".format(
            pbn0_val
        ),
        "BW_ACTION: ATTEMPT_PBN1 (PBN {}).".format(pbn1_val),
        "TEST_DRIVER: Scenario 1 finished.",
    )


@test(10, "mp4 problem II public testcase: RAID1 Mirroring Verification (Criterion 1)")
def test_mirror_verification():
    r.run_qemu(shell_script(["echo .", "mp4_2_mirror_test"]))
    r.match_substrings_ordered(
        "Bwrite Mirroring Test: PASS",
    )


@test(
    10,
    "mp4 problem II public testcase: Bread RAID1 Disk Fail Read Fallback Verification (Criterion 2)",
)
def test_fallback_verification():
    r.run_qemu(shell_script(["echo .", "mp4_2_disk_failure_test"]))
    r.match_substrings_ordered("Bread Disk Failure Fallback Test: PASS")


run_tests()
