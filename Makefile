
make_tile:
	ruby -Ilib lib/make_tile.rb
mt: make_tile
tile: make_tile


.PHONY: make_tile

