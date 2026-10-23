extends RefCounted
## Membuat soal aritmetika dasar untuk MVP Math-Adventure.

static func make_question() -> Dictionary:
	var a: int = randi_range(2, 20)
	var b: int = randi_range(1, 20)
	var operator: String = "+" if randi_range(0, 1) == 0 else "-"
	var answer: int

	if operator == "-":
		if b > a:
			var temporary: int = a
			a = b
			b = temporary
		answer = a - b
	else:
		answer = a + b

	var options: Array[int] = [answer]
	while options.size() < 4:
		var candidate: int = answer + randi_range(-10, 10)
		if candidate >= 0 and not options.has(candidate):
			options.append(candidate)
	options.shuffle()

	return {
		"a": a,
		"b": b,
		"operator": operator,
		"answer": answer,
		"options": options
	}
