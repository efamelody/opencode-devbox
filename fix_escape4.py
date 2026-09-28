with open('devbox', 'r', encoding='utf-8') as f:
    content = f.read()

# Find the escape_html function and replace it entirely
import re

# Pattern to match the escape_html function
pattern = r'def escape_html\(text: str\) -> str:.*?^    \)'
# Use DOTALL to match across lines

# Find it
match = re.search(r'def escape_html\(text: str\) -> str:.*?^\s*\)', content, re.MULTILINE | re.DOTALL)
if match:
    print(f"Found at {match.start()}-{match.end()}")
    print(repr(match.group()[:200]))
else:
    print("Not found with pattern")

# Let's just find the exact text and replace
# The issue is the line with .replace('"', """)
# Let's find all occurrences of this pattern
for m in re.finditer(r'\.replace\(\'"\', """)', content):
    print(f"Found at {m.start()}: {repr(content[m.start()-20:m.end()+20])}")

# Replace the specific broken line
content = content.replace('.replace(\'"\', """)', '.replace(\'"\', \"\"\")')

with open('devbox', 'w', encoding='utf-8') as f:
    f.write(content)

print('Fixed')