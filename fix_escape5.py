with open('devbox', 'r', encoding='utf-8') as f:
    content = f.read()

# The exact broken string we need to fix
broken = '.replace(\'"\', """)'
fixed = '.replace(\'"\', """")'

if broken in content:
    content = content.replace(broken, fixed)
    print(f"Replaced {content.count(broken)} occurrences")
else:
    print("Broken string not found")

with open('devbox', 'w', encoding='utf-8') as f:
    f.write(content)

print('Done')