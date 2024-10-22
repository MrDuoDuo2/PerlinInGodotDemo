extends CharacterBody3D


const SPEED = 5.0
const JUMP_VELOCITY = 7

@onready var robot_skeleton: Node3D = $Robot_Skeleton
var LERP_VAL = .15
@onready var spring_arm: Node3D = $SpringArm

@onready var spring_arm_3d: SpringArm3D = $SpringArm/SpringArm3D

func _ready() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _unhandled_input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("quit"):
		get_tree().quit()
	
	if event is InputEventMouseMotion:
		#print(event)
		spring_arm.rotate_y(-event.relative.x * .005)
		spring_arm_3d.rotate_x(-event.relative.y * .005)
		spring_arm_3d.rotation.x = clamp(spring_arm_3d.rotation.x,-PI/4,PI/4)

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta
		

	# Handle jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY
		
	if Input.is_action_just_pressed("scroll_down"):
		spring_arm_3d.position.z += 5 * delta
		
	if Input.is_action_just_pressed("scroll_up"):
		spring_arm_3d.position.z -= 5 * delta
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var input_dir := Input.get_vector("move_left", "move_right", "move_up", "move_down")
	var direction := (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
		
	direction = direction.rotated(Vector3.UP,spring_arm.rotation.y)
	if direction:
		#print(direction)
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
		robot_skeleton.rotation.y = lerp_angle(robot_skeleton.rotation.y,atan2(velocity.x,velocity.z),LERP_VAL)
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)

	move_and_slide()
