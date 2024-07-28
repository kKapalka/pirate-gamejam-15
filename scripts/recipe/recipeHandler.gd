extends Node

@export var resourceRecipeArray: Array[ResourceRecipe] = []

func loadResourceRecipe(id: String) -> ResourceRecipe:
	return resourceRecipeArray.filter(func(recipe: ResourceRecipe): return recipe.id == id)[0]

func findCombination(ingredients : Array[String]) -> ResourceRecipe:
	if ingredients.size() != 3:
		return null
	var recipes = resourceRecipeArray.duplicate()
	print(recipes.map(func(x): return x.ingredientsId))
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
