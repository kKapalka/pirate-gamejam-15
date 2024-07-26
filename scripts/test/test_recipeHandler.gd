extends Node


# Called when the node enters the scene tree for the first time.
func _ready():
	var recipes = RecipeHandler.resourceRecipeArray
	var recipe1 = createAndSetRecipe(['copper', 'iron','tin'], 'gold', 1)
	var recipe2 = createAndSetRecipe(['copper', 'water','fire'], 'carbon', 2)
	var recipe3 = createAndSetRecipe(['water', 'fire','earth'], 'mud', 3)
	var recipe4 = createAndSetRecipe([], 'waste', 3)
	recipes.append(recipe1)
	recipes.append(recipe2)
	recipes.append(recipe3)
	recipes.append(recipe4)
	
	var result1 = RecipeHandler.findCombination(['iron','tin','copper'])
	var result2 = RecipeHandler.findCombination(['water','fire','copper'])
	var result3 = RecipeHandler.findCombination(['copper','fire','wind'])
	print(result1.id + " " + result2.id + " " + result3.id)

func createAndSetRecipe(ingredients : Array[String], result : String, count : int) -> ResourceRecipe:
	var recipe = ResourceRecipe.new()
	recipe.ingredientsId = ingredients
	recipe.id = result + "Recipe"
	recipe.resultId = result
	recipe.resultCount = count
	return recipe
