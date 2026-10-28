extends RefCounted
## Soal dunia 1: tambah/kurang; dunia 2: kali/bagi; dunia 3: pecahan/persentase.

static func make_question(difficulty: String = "mudah", world_id: int = 1) -> Dictionary:
	var diff: String = difficulty.to_lower()
	var min_value: int = 0
	var max_value: int = 10
	var reward: int = 25
	var difficulty_label: String = "Mudah"
	match diff:
		"sedang", "medium":
			min_value = 5
			max_value = 15
			reward = 35
			difficulty_label = "Sedang"
		"sulit", "hard":
			min_value = 10
			max_value = 30
			reward = 45
			difficulty_label = "Sulit"
		_:
			min_value = 0
			max_value = 10
			reward = 25
			difficulty_label = "Mudah"
	if world_id == 2:
		return _make_multiplication_division(difficulty_label, reward)
	if world_id == 3:
		return _make_fraction_percentage(diff, difficulty_label, reward)
	return _make_addition_subtraction(min_value, max_value, reward, difficulty_label)

static func _make_addition_subtraction(min_value: int, max_value: int, reward: int, label: String) -> Dictionary:
	var a: int = randi_range(min_value, max_value)
	var b: int = randi_range(min_value, max_value)
	var operator: String = "+" if randi_range(0, 1) == 0 else "−"
	var answer: int
	if operator == "−":
		if b > a:
			var temp: int = a
			a = b
			b = temp
		answer = a - b
	else:
		answer = a + b
	return {"question": "%d %s %d" % [a, operator, b], "answer": str(answer), "options": _numeric_options(answer, maxi(4, int(round(float(max_value) * 0.22)))), "reward": reward, "difficulty": label, "world_id": 1}

static func _make_multiplication_division(label: String, reward: int) -> Dictionary:
	var a: int
	var b: int
	var answer: int
	var operator: String
	if randi_range(0, 1) == 0:
		var upper_factor: int = 5 if label == "Mudah" else (9 if label == "Sedang" else 12)
		a = randi_range(2, upper_factor)
		b = randi_range(2, upper_factor)
		answer = a * b
		operator = "×"
	else:
		b = randi_range(2, 10 if label == "Sulit" else 6)
		answer = randi_range(2, 12 if label == "Sulit" else 10)
		a = b * answer
		operator = "÷"
	return {"question": "%d %s %d" % [a, operator, b], "answer": str(answer), "options": _numeric_options(answer, maxi(5, int(round(float(answer) * 0.3)))), "reward": reward, "difficulty": label, "world_id": 2}

static func _make_fraction_percentage(difficulty: String, label: String, reward: int) -> Dictionary:
	var question_text: String
	var answer_text: String
	var options: Array[String] = []
	var pattern: int = randi_range(0, 2)
	if pattern == 0:
		var equiv_numerator: int = 1 if difficulty != "sulit" else randi_range(1, 3)
		var equiv_denominator: int = 2 if equiv_numerator == 1 else 4
		var pct: int = int(round(float(equiv_numerator) / float(equiv_denominator) * 100.0))
		question_text = "Persentase dari %d/%d" % [equiv_numerator, equiv_denominator]
		answer_text = "%d%%" % pct
		options = ["25%", "50%", "75%", "100%"]
	elif pattern == 1:
		var percent_choices: Array[int] = [10, 25, 50, 75]
		var percent: int = percent_choices[randi_range(0, percent_choices.size() - 1)]
		var whole_choices: Array[int] = [20, 40, 60, 80]
		var percent_whole: int = whole_choices[randi_range(0, whole_choices.size() - 1)]
		var percent_answer: int = int(float(percent_whole * percent) / 100.0)
		question_text = "%d%% dari %d" % [percent, percent_whole]
		answer_text = str(percent_answer)
		options = _numeric_options(percent_answer, maxi(4, int(percent_whole / 10)))
	else:
		var fraction_denominator: int = 2 if difficulty == "mudah" else 4
		var fraction_numerator: int = 1 if fraction_denominator == 2 else randi_range(1, 3)
		var fraction_whole: int = fraction_denominator * randi_range(2, 10)
		var fraction_answer: int = int(float(fraction_whole * fraction_numerator) / float(fraction_denominator))
		question_text = "%d/%d dari %d" % [fraction_numerator, fraction_denominator, fraction_whole]
		answer_text = str(fraction_answer)
		options = _numeric_options(fraction_answer, maxi(4, int(fraction_whole / 8)))
	if not options.has(answer_text):
		options[0] = answer_text
	options.shuffle()
	return {"question": question_text, "answer": answer_text, "options": options, "reward": reward, "difficulty": label, "world_id": 3}

static func _numeric_options(answer: int, spread: int) -> Array[String]:
	var options: Array[String] = [str(answer)]
	var attempts: int = 0
	while options.size() < 4 and attempts < 120:
		attempts += 1
		var candidate: int = answer + randi_range(-spread, spread)
		if candidate >= 0 and not options.has(str(candidate)):
			options.append(str(candidate))
	var fallback: int = 0
	while options.size() < 4:
		if not options.has(str(answer + fallback)):
			options.append(str(answer + fallback))
		fallback += 1
	options.shuffle()
	return options
