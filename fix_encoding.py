with open('devbox', 'r', encoding='utf-8') as f:
    content = f.read()

# Fix the template reading to use UTF-8 encoding
old = '''    with open(template_path, "r") as f:
        template = f.read()'''

new = '''    with open(template_path, "r", encoding="utf-8") as f:
        template = f.read()'''

content = content.replace(old, new)

with open('devbox', 'w', encoding='utf-8') as f:
    f.write(content)

print('Fixed template encoding')