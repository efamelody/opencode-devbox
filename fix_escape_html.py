with open('devbox', 'r', encoding='utf-8') as f:
    content = f.read()

# Fix the escape_html function properly
import re

# Find the function
match = re.search(r'def escape_html\(text: str\) -> str:.*?^    \)', content, re.MULTILINE | re.DOTALL)
if match:
    print('Found function')
    
    new_func = '''def escape_html(text: str) -> str:
    if not text:
        return ""
    return (text
        .replace("&", "&")
        .replace("<", "<")
        .replace(">", ">")
        .replace("\\"", "\\"")
        .replace("\\'", "\\'")
        .replace("\\n", "<br>")
    )'''
    
    content = content[:match.start()] + new_func + content[match.end():]
    print('Replaced function')
else:
    print('Function not found')

with open('devbox', 'w', encoding='utf-8') as f:
    f.write(content)

print('Done')