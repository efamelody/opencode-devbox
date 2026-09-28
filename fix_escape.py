with open('devbox', 'r', encoding='utf-8') as f:
    content = f.read()

# Replace the problematic function - find and replace the exact escape_html function
old_func = '''def escape_html(text: str) -> str:
    if not text:
        return ""
    return (text
        .replace("&", "&")
        .replace("<", "<")
        .replace(">", ">")
        .replace('"', "")
        .replace("'", "'")
        .replace("\\n", "<br>")
    )'''

new_func = '''def escape_html(text: str) -> str:
    if not text:
        return ""
    return (text
        .replace("&", "&")
        .replace("<", "<")
        .replace(">", ">")
        .replace('"', """)
        .replace("'", "'")
        .replace("\\n", "<br>")
    )'''

content = content.replace(old_func, new_func)

with open('devbox', 'w', encoding='utf-8') as f:
    f.write(content)

print('Fixed escape_html function')