with open('devbox', 'r', encoding='utf-8') as f:
    content = f.read()

# Find all triple quote positions
triple_quotes = []
pos = 0
while True:
    idx = content.find('"""', pos)
    if idx == -1:
        break
    triple_quotes.append(idx)
    pos = idx + 3

print(f"Found {len(triple_quotes)} triple-quote sequences")
for i, tq in enumerate(triple_quotes):
    context = content[max(0, tq-30):tq+30]
    print(f"  {i}: pos={tq}, context={repr(context)}")