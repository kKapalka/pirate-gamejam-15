extends Node

@export var resourceRecipeArray: Array[ResourceRecipe] = []

func loadResourceRecipe(id: String) -> ResourceRecipe:
	return resourceRecipeArray.filter(func(recipe: ResourceRecipe): return recipe.id == id)[0]

func findCombination(ingredients : Array[String]) -> ResourceRecipe:
	if ingredients.size() != 3:
		return loadResourceRecipe('wasteRecipe')
	var recipes = resourceRecipeArray
	recipes = filterArrayByIngredient(recipes, ingredients[0])
	recipes = filterArrayByIngredient(recipes, ingredients[1])
	recipes = filterArrayByIngredient(recipes, ingredients[2])
	if recipes.size() == 1:
		return recipes[0]
	return loadResourceRecipe('wasteRecipe')

func filterArrayByIngredient(recipes : Array[ResourceRecipe],ingredientP : String) -> Array[ResourceRecipe]:
	if recipes == []:
		return []
	return recipes.filter(func(recipe : ResourceRecipe): return recipe.ingredientsId.any(func(ingredient : String): return ingredient == ingredientP))
