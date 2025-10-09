extends CanvasLayer


var gradient = GradientTexture2D.new()
var grad = Gradient.new()
grad.colors = [Color(0.1,0.1,0.1), Color(0.2,0.2,0.2)]
gradient.gradient = grad
$ColorRect.texture = gradient
