extends Node

var applied_modifiers: Array[ModifierStatic] = []

func get_modifiers_of_type(type: String) -> Array[ModifierStatic]:
  var modifiers: Array[ModifierStatic] = []
  for mod in applied_modifiers:
    if mod.name == type:
      modifiers.append(mod)
  return modifiers
  
func get_modifier_value_of_type(type: String, default: float) -> float:
  var modifiers: Array[ModifierStatic] = get_modifiers_of_type(type)
  var val: float = default
  for mod in modifiers:
    val += mod.val
  return val

var wpn_damage_perc: float = 1:
  get: return get_modifier_value_of_type('wpn_damage_perc', 1)
var wpn_damage_base: float = 0:
  get: return get_modifier_value_of_type('wpn_damage_base', 0)
var wpn_speed_perc: float = 1:
  get: return get_modifier_value_of_type('wpn_speed_perc', 1)
var wpn_drag_perc: float = 1:
  get: return get_modifier_value_of_type('wpn_drag_perc', 1)
var wpn_steering_perc: float = 1:
  get: return get_modifier_value_of_type('wpn_steering_perc', 1)

class Modifier:
  var name: String
  var val: Callable
  var description: Callable

  func _init(_name: String, _val: Callable, _description: Callable) -> void:
    self.name = _name
    self.val = _val
    self.description = _description

class ModifierStatic:
  var name: String
  var val: float
  var description: String

  func _init(_name: String, _val: float, _description: String) -> void:
    self.name = _name
    self.val = _val
    self.description = _description

var possible_modifiers: Array[Modifier] = [
  Modifier.new(
    'wpn_damage_perc',
    func() -> float: return float("%.2f" % randf_range(0.01, 0.2)),
    func(val: float) -> String: return '[b]%.0f%%[/b] more bullet damage' % (val * 100),
  ),
  Modifier.new(
    'wpn_damage_base',
    func() -> float: return roundf(randf_range(1, 5)),
    func(val: float) -> String: return '[b]%.0f[/b] more bullet damage' % val,
  ),
  Modifier.new(
    'wpn_speed_perc',
    func() -> float: return float("%.2f" % randf_range(0.01, 0.2)),
    func(val: float) -> String: return '[b]%.0f%%[/b] faster bullet speed' % (val * 100),
  ),
  Modifier.new(
    'wpn_drag_perc',
    func() -> float: return float("%.2f" % randf_range(0.01, 0.2)),
    func(val: float) -> String: return '[b]%.0f%%[/b] less bullet drag' % (val * 100),
  ),
  Modifier.new(
    'wpn_steering_perc',
    func() -> float: return float("%.2f" % randf_range(0.01, 0.2)),
    func(val: float) -> String: return '[b]%.0f%%[/b] more bullet steering' % (val * 100),
  ),
]

func get_random_modifier() -> ModifierStatic:
  var modifier := possible_modifiers[randi_range(0, possible_modifiers.size() - 1)]
  var val: float = modifier.val.call()
  return ModifierStatic.new(modifier.name, val, modifier.description.call(val) as String)

func get_random_modifiers(count: int) -> Array[ModifierStatic]:
  var modifiers: Array[ModifierStatic] = []
  var unique_modifier_names: Array[String] = []
  while modifiers.size() < count:
    var modifier := get_random_modifier()
    if not unique_modifier_names.has(modifier.name):
      unique_modifier_names.append(modifier.name)
      modifiers.append(modifier)
  return modifiers

func apply_modifier(mod: ModifierStatic) -> void:
  applied_modifiers.append(mod)