## Troubleshooting

After installing lua and lua includes, use this command on luarocks directory (https://luarocks.org/):

`./configure --with-lua=/usr && make && sudo make install`

- why?

Since `./configure` does not try to find lua under `/usr/bin`.
