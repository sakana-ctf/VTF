def list_file():
    import os
    base_dir = os.getcwd()
    files = os.listdir(f'{base_dir}/html')
    return files

def set_html(main_html, url='html/'):
    with open('head.html') as f:
        head = f.read()
    with open('header.html') as f:
        header = f.read()
    with open(f'{url}/{main_html}') as f:
        main = f.read()
    with open('js.html') as f:
        js = f.read()
    return f'<!DOCTYPE html>\n<html lang="zh">\n{head}\n<body id="top">\n{header}\n{main}\n{js}\n</body>\n</html>'

def write_html(i, data, url='../templates'):
    with open(f'{url}/{i}', 'w') as f:
        f.write(data)
    print(f'\033[32m[True] \033[0m文件储存于: {url}/{i}')

def main():
    for i in list_file():
        write_html(i, set_html(i))

if __name__ == '__main__':
    main()
