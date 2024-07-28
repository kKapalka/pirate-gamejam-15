extends Node

var resourceRecipeArray: Array[ResourceRecipe]

func _ready():
	var path = "res://resources/recipe"
	var dir = DirAccess.open(path)
	if dir:
		dir.list_dir_begin()
		var file_name = dir.get_next()
		while file_name != "":
			var recipe = ResourceLoader.load(path+"/"+file_name) as ResourceRecipe
			resourceRecipeArray.append(recipe)
			file_name = dir.get_next()

func loadResourceRecipe(id: String) -> ResourceRecipe:
	return resourceRecipeArray.filter(func(recipe: ResourceRecipe): return recipe.id == id)[0]

func findCombination(ingredients : Array[String]) -> ResourceRecipe:
	if ingredients.size() != 3:
		return null
	var recipes = resourceRecipeArray.duplicate()
	recipes = filterArrayByIngredient(recipes, ingredients[0])
	recipes = filterArrayByIngredient(recipes, ingredients[1])
	recipes = filterArrayByIngredient(recipes, ingredients[2])
	if recipes.size() == 1:
		return recipes[0]
	return null

func filterArrayByIngredient(recipes : Array[ResourceRecipe],ingredientP : String) -> Array[ResourceRecipe]:

	if recipes == []:
		return []
	if ingredientP == "blank":
		return recipes
	return recipes.filter(func(recipe : ResourceRecipe): return ingredientP in recipe.ingredientsId)
