extends RefCounted
## Pembuat soal aritmetika untuk Math-Adventure.
## Wave 1 memakai angka kecil, wave 2 menengah, dan wave 3 angka lebih besar.

static func make_question(difficulty: String = "mudah") -> Dictionary:
	var min_value: int = 0
	var max_value: int = 10
	var reward: int = 25
	var difficulty_label: String = "Mudah"

	# Rentang dibuat bertahap untuk anak SD. Angka pada tiap operasi
	# dijaga agar tidak terlalu besar dan pengurangan tidak menghasilkan negatif.
	match difficulty.to_lower():
		"sedang", "medium":
			min_value = 5
			max_value = 15
			reward = 35
			difficulty_label = "Sedang"
		"sulit", "hard":
			min_value = 20
			max_value = 50
			reward = 45
			difficulty_label = "Sulit"
		_:
			min_value = 0
			max_value = 10
			reward = 50
			difficulty_label = "Mudah"

	var a: int = randi_range(min_value, max_value)
	var b: int = randi_range(min_value, max_value)
	var operator: String = "+" if randi_range(0, 1) == 0 else "-"
	var answer: int = 0

	if operator == "-":
		if b > a:
			var temporary: int = a
			a = b
			b = temporary
		answer = a - b
	else:
		answer = a + b

	var options: Array[int] = [answer]
	var attempts: int = 0
	var spread: int = maxi(5, int(round(float(max_value) * 0.22)))
	while options.size() < 4 and attempts < 120:
		attempts += 1
		var candidate: int = answer + randi_range(-spread, spread)
		if candidate >= 0 and not options.has(candidate):
			options.append(candidate)

	# Fallback menjamin selalu ada empat pilihan berbeda.
	var fallback: int = 0
	while options.size() < 4:
		if not options.has(answer + fallback):
			options.append(answer + fallback)
		fallback += 1

	options.shuffle()
	return {
		"a": a,
		"b": b,
		"operator": operator,
		"answer": answer,
		"options": options,
		"difficulty": difficulty_label,
		"reward": reward
	}
