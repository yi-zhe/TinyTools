# coding=utf-8
import re

# 1. rename never used parameter to _
renameNeverUsedParameterPattern = re.compile(
    r"w: ([/\w]+).kt: \((\d+), \d+\): Parameter '(\w+)' is never used, could be renamed to _")


# 处理assembleRelease中出现的一些类型的警告
def parse_build_output(path):
    build_output = open(path)
    for line in build_output:
        rename_never_used_parameter_to_(line, True)
        change_adapter_position(line, True)
        find_condition_the_same(line, True)
        remove_unnecessary_safe_call(line, True)

# 2. change getter for adapterPosition to bindingAdapterPosition
changeAdapterPositionToBindingAdapterPositionPattern = re.compile(
    r"w: ([/\w]+).kt: \((\d+), \d+\): 'getter for adapterPosition: Int' is deprecated. Deprecated in Java")


def rename_never_used_parameter_to_(line, print_to):
    segments = re.search(renameNeverUsedParameterPattern, line)
    if segments is not None:
        kt_file = segments.group(1) + '.kt'
        line_num = segments.group(2)
        var = segments.group(3)
        if print_to:
            print("sed -i '' %ss/%s/_/g %s" % (line_num, var, kt_file))


def change_adapter_position(line, print_to):
    segments = re.search(changeAdapterPositionToBindingAdapterPositionPattern, line)
    if segments is not None:
        kt_file = segments.group(1) + '.kt'
        line_num = segments.group(2)
        if print_to:
            print("sed -i '' %ss/adapterPosition/bindingAdapterPosition/ %s" % (line_num, kt_file))


# 3. Condition 'countDownTimer != null' is always 'true' 'false'
conditionIsAlwaysTheSame = re.compile(
    r"w: ([/\w]+).kt: \((\d+), \d+\): Condition '([ =!\w]+)' is always '(\w+)'")

def find_condition_the_same(line, print_to):
    segments = re.search(conditionIsAlwaysTheSame, line)
    if segments is not None:
        kt_file = segments.group(1) + '.kt'
        line_num = segments.group(2)
        condition = segments.group(3)
        value = segments.group(4)
        if print_to:
            print("%s:%s %s %s" % (kt_file, line_num, condition, value))


# 4. Unnecessary safe call on a non-null receiver of type X
unnecessarySafeCall = re.compile(
    r"w: ([/\w]+).kt: \((\d+), \d+\): Unnecessary safe call on a non-null receiver of type")


def remove_unnecessary_safe_call(line, print_to):
    segments = re.search(unnecessarySafeCall, line)
    if segments is not None:
        kt_file = segments.group(1) + '.kt'
        line_num = segments.group(2)
        if print_to:
            print("sed -i '' %ss/\?// %s" % (line_num, kt_file))


if __name__ == '__main__':
    parse_build_output('/Users/liuyang/Desktop/a.txt')
