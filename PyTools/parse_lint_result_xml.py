# coding=utf-8

import re
import xml.dom.minidom

pattern = re.compile(r"`R.\w+.(\w+)`")


def parse_lint(lint_xml_path):
    dom = xml.dom.minidom.parse(lint_xml_path)
    root = dom.documentElement
    issues = root.getElementsByTagName('issue')

    rms = ['R.drawable', 'R.mipmap', 'R.layout', 'R.menu', 'R.xml', 'R.anim', 'R.raw', 'R.navigation']
    seds = ['R.string', 'R.color', 'R.integer', 'R.dimen']
    others = ['R.style']

    results = {}

    for rm in rms:
        results[rm] = []
    for sed in seds:
        results[sed] = []
    for other in others:
        results[other] = []

    for issue in issues:
        if issue.getAttribute('id') == 'UnusedResources':
            location = issue.getElementsByTagName('location')
            path = location[0].getAttribute('file')
            message = issue.getAttribute('message')
            for title, result in results.items():
                if title not in message:  # 确保message中出现了我们定义的类别
                    continue
                if title in rms:  # 可以直接删除的
                    results[title].append('rm %s' % path)
                    pass
                elif title in seds:  # 在文件中原地替换的
                    name = re.search(pattern, message)
                    results[title].append("sed -i '' '/\"%s\"/d' %s" % (name.group(1), path))
                    pass
                elif title in others:  # 需要人工处理的指明文件路径, 待处理资源的名字和行号
                    line = location[0].getAttribute('line')
                    name = re.search(pattern, message)
                    results[title].append('%s: %s:%s' % (path, name.group(1), line))
                    pass

    for title in sorted(results.keys()):
        print('Unused %s' % title)
        for item in results[title]:
            print(item)


if __name__ == '__main__':
    parse_lint('/Users/liuyang/Desktop/lint-results.xml')
