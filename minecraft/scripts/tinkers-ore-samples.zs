#loader contenttweaker

/* tinkers-ore-samples.zs - v1.0
 *  Author:  QBFreak
 *  License: GNU GPL v3.0
 *
 *  Create custom Geolosys samples for Tinkers' Construct Cobalt Ore and
 *   Ardite Ore using ContentTweaker. The model supports two-layer textures
 *   such as those used by the Tinkers' Construct ores. The model overlays the
 *   ore texture on top of the minecraft:blocks/stone texture to produce the
 *   final product.
 *
 *  Todo:
 *  - Perform (item) drop when block underneath is broken (this is how Geolosys
 *      samples behave). `sample.onBlockBreak()` seems like a good spot for
 *      this. I'm just not sure how to trigger the drop.
 */

// Import all the things we're going to need
import crafttweaker.creativetabs.ICreativeTab;
import crafttweaker.item.IItemDefinition;
import crafttweaker.item.IItemStack;
import crafttweaker.world.IBlockPos;
import crafttweaker.world.IBlockAccess;

import mods.contenttweaker.AxisAlignedBB;
import mods.contenttweaker.Block;
import mods.contenttweaker.BlockState;
import mods.contenttweaker.DropHandler;
import mods.contenttweaker.ItemList;
import mods.contenttweaker.ResourceLocation;
import mods.contenttweaker.VanillaFactory;

/* logName - An identifier for our logging output
 *  This makes filtering and highlighting logs much easier.
 *  Change to reflect your modpack or script as you desire.
 */

static logName as string = "ORE SAMPLE";


/* samples[] - An associative array of name/drops to add
 *  Additional samples can be created simply by adding a new element to the
 *   array and creating a corresponding blockstate JSON to specify the textures
 *
 * Why are we using the Item Bracket Handler? (<item:>)
 *  See https://github.com/The-Acronym-Coders/ContentTweaker/issues/165#issuecomment-451653244
 *
 * Why are we `static samples as IItemStack[string] = {}` when the example is
 *  `samples = {} as IItemStack[string]` ? Because in the latter `samples` is
 *  type Any. If you used `var` instead of `static` this wouldn't be an issue,
 *  casting would take care of it. But once we declare something static, it
 *  can't be changed, and the cast fails. IMO the type should be on the left
 *  side of the assignment operator anyway...
 */

static samples as IItemStack[string] = {
    cobalt : <item:tconstruct:ore:0>,
    ardite : <item:tconstruct:ore:1>
};


/*
 * Some logging wrappers, so that we use the identifier prefix as set above
 */

function logCommand(message as string) as void {
    logger.logCommand("[" + logName + "] " + message);
}

function logInfo(message as string) as void {
    // logger.logInfo("[" + logName + "] " + message);
    logCommand("   [INFO] " + message);
}

function logWarning(message as string) as void {
    // logger.logWarning("[" + logName + "] " + message);
    logCommand("[WARNING] " + message);
}

function logError(message as string) as void {
    // logger.logError("[" + logName + "] " + message);
    logCommand("  [ERROR] " + message);
}


/*
 * subString() returns the remainder of `input`, removing `index` characters
 */

function subString(input as string, index as int) as string{
    var returner as string = "";

    for i in index to (input.length){
        returner ~= input[i];
    }
 
    return returner;
}


/*
 * createSample() generates the block for a given sample
 */

function createSample(sampleName as string) as void {
    if (sampleName == "") {
        logError("Error creating sample, no name specified.");
        return;
    }

    logInfo("Creating sample " + sampleName);
    var sample as Block = VanillaFactory.createBlock("sample_" + sampleName, <blockmaterial:ground>);
    sample.axisAlignedBB = AxisAlignedBB.create(0.2, 0.0, 0.2, 0.8, 0.25, 0.8);
    sample.blockHardness = 0.125;
    sample.blockLayer = "CUTOUT_MIPPED";
    sample.blockResistance = 2.0;
    sample.blockSoundType = <soundtype:ground>;
    sample.creativeTab = <creativetab:buildingBlocks>;
    sample.fullBlock = false;
    sample.gravity = true;
    sample.lightOpacity = 0;
    sample.setToolLevel(0);

    sample.setDropHandler(function(drops as ItemList, world as IBlockAccess, position as IBlockPos, state as BlockState, fortune as int) {
        /*
         * This unnamed function is our IBlockDropHandler. It runs each time the
         *  block is ready to perform the drop.
         */

        // Why are we doing this (apparently) silly string manipulation nonsense?
        //  Because sampleName from createSample() was out of the current scope.
        var prefix as string = "contenttweaker:sample_";
        var sampleName as string = state.getBlock().definition.id;

        // Sanity check! A healthy mistrust of data quality keeps the fatal errors down...
        if (sampleName.length <= prefix.length) {
            logError("sampleName length too short (" + sampleName.length + ") for string '" + sampleName + "'");
            return;
        }

        // Cut down the block ID to get the sample name
        sampleName = subString(sampleName, prefix.length);

        // Don't want to drop a new sample when it is mined, only the new drop
        drops.clear();

        // Look up the IItemStack and add it as a drop
        drops.add(samples[sampleName]);

        return;
    });

    // Woo! Register that puppy!
    sample.register();
}

// Loop through the associative array samples[] and create a sample for each element
for sampleName, drop in samples {
    createSample(sampleName);
}
