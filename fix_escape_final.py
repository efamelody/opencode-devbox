with open('devbox', 'r', encoding='utf-8') as f:
    content = f.read()

# Find and replace the entire escape_html function
import re

# Find the function
match = re.search(r'def escape_html\(text: str\) -> str:.*?^    \)', content, re.MULTILINE | re.DOTALL)
if match:
    old_func = match.group()
    print('Found function at', match.start(), '-', match.end())
    
    # Create new function - use chr() to avoid quote issues
    amp = chr(38)
    lt = chr(60)
    gt = chr(62)
    quot = chr(34)
    apos = chr(39)
    backslash = chr(92)
    n = chr(10)
    
    new_func = f'''def escape_html(text: str) -> str:
    if not text:
        return ""
    return (text
        .replace("{amp}", "{amp}")
        .replace("{lt}", "{lt}")
        .replace("{gt}", "{gt}")
        .replace("{quot}", "{quot}")
        .replace("{apos}", "{apos}")
        .replace("{backslash}n", "<br>")
    )'''
    
    content = content[:match.start()] + new_func + content[match.end():]
    print('Replaced function')
else:
    print('Function not found')

with open('devbox', 'w', encoding='utf-8') as f:
    f.write(content)

print('Done')