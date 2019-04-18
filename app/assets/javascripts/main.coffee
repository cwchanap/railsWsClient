# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
$ -> 
    canvas = $("#myCanvas").get(0)
    ctx = canvas.getContext("2d")
    ball_radius = 20
    paddleHeight = 10
    paddleWidth = 200
    paddleX = 0
    rightPressed = false
    leftPressed = false 
    move_size = 10

    x = ball_radius
    y = canvas.height / 2
    dx = 15
    dy = 10   

    resizeCanvas = ->
        canvas.width = window.innerWidth
        canvas.height = window.innerHeight - 20

        paddleX = (canvas.width - paddleWidth) / 2     

        if x >= canvas.width - ball_radius
            x = canvas.width - ball_radius      
        if y >= canvas.height - ball_radius
            y = canvas.height - ball_radius                

    drawBall = ->
        ctx.beginPath()
        ctx.arc(x, y, ball_radius, 0, Math.PI*2, false)
        ctx.fillStyle = "green"
        ctx.fill()
        ctx.closePath()

    drawPaddle = ->
        ctx.beginPath()
        ctx.rect(paddleX, canvas.height-paddleHeight, paddleWidth, paddleHeight)
        ctx.fillStyle = "#0095DD"
        ctx.fill()
        ctx.closePath()

    draw = ->
        ctx.clearRect(0, 0, canvas.width, canvas.height)
        drawBall()
        drawPaddle()
        if !(x <= canvas.width - ball_radius && x >= ball_radius)
            dx = -dx
        if !(y <= canvas.height - ball_radius && y >= ball_radius)
            dy = -dy
        
        if rightPressed && paddleX < canvas.width-paddleWidth 
            paddleX += move_size
        else if leftPressed && paddleX > 0
            paddleX -= move_size
    
        x += dx
        y += dy

    paddleHandler = (e, value) ->
        if e.key == "Right" || e.key == "ArrowRight" 
            rightPressed = value
        else if e.key == "Left" || e.key == "ArrowLeft"
            leftPressed = value

    keyDownHandler = (e) -> paddleHandler(e, true)
    keyUpHandler = (e) -> paddleHandler(e, false)

    window.addEventListener('resize', resizeCanvas, false)        
    window.addEventListener("keydown", keyDownHandler, false)
    window.addEventListener("keyup", keyUpHandler, false)      
    resizeCanvas()
    setInterval(draw, 20)