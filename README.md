# Geolosys Custom Ore Samples

[Geolosys](https://minecraft.curseforge.com/projects/geolosys) is a cool Minecraft mod for ore generation. It includes samples on the
surface. This is a demonstration of a set of [CraftTweaker](https://minecraft.curseforge.com/projects/crafttweaker) and [ContentTweaker](https://minecraft.curseforge.com/projects/contenttweaker)
scripts to add ores with custom ore samples.

## The ores

This example uses [Tinkers' Construct](https://minecraft.curseforge.com/projects/tinkers-construct) Cobalt Ore and Ardite Ore. They are
configured to generate in the overworld, so the sample textures use Stone
as a base, instead of Netherrack. You may use any texture you wish.

There is a companion resourcepack to give the Tinkers' Cobalt Ore and Ardite
Ore blocks stone textures as well.

## The pieces

### scripts/tinkers-ore-samples.zs

This is the heart of the demo. It is the script to create the custom sample
blocks. New samples are added to the associative array named `samples` and the
script takes care of the rest. The new blocks names are prefixed with `sample_`.

### scripts/tinkers-ores.zs

This is the CraftTweaker script to add the ores, with our custom samples, to
the Geolosys ore gen.

### resources/contenttweaker/blockstates/sample_*.json

This is where the textures for the samples get set.

- `particle` is for the particles on block breaking
- `all` is the texture of the ore, this can include transparency. If your textures require two layers, such as the Tinkers' ores, this is where you set the upper-most layer
- `base` is the texture that `all` will be overlaid upon. If your textures require two layers, such as the Tinkers' ores, this is where you set the bottom layer

### resources/contenttweaker/lang/en_us.lang

This is the English language file for the sample block names.

### resources/contenttweaker/models/block/sample.json

This is my modified version of the stock Geolosys Sample model. It provides a
second layer for textures with transparency.

### /resourcepacks/PipCraft-1.0.zip

Part of another project. Vanilla-style textures for Geolosys, as well as
overworld-style textures for the Tinkers' ores. The Geolosys textures were
created by  and realeased as [Minecraftic Geolosys](https://minecraft.curseforge.com/projects/mod-ctm-minecraftic-geolosys)
I removed the CTM, as I didn't care for it, and incorporated it with my
Tinkers' textures. As for the name, it's intended to be a companion resoucepack
to a modpack that's in development.
