// Canvas game logic
document.addEventListener('DOMContentLoaded', () => {
  const canvas = document.getElementById("myCanvas");
  if (!canvas) return;

  const ctx = canvas.getContext("2d");
  const ball_radius = 20;
  const paddleHeight = 10;
  const paddleWidth = 200;
  let paddleX = 0;
  let rightPressed = false;
  let leftPressed = false;
  const move_size = 10;

  let x = ball_radius;
  let y = canvas.height / 2;
  let dx = 15;
  let dy = 10;

  const resizeCanvas = () => {
    canvas.width = window.innerWidth;
    canvas.height = window.innerHeight - 20;

    paddleX = (canvas.width - paddleWidth) / 2;

    if (x >= canvas.width - ball_radius) {
      x = canvas.width - ball_radius;
    }
    if (y >= canvas.height - ball_radius) {
      y = canvas.height - ball_radius;
    }
  };

  const drawBall = () => {
    ctx.beginPath();
    ctx.arc(x, y, ball_radius, 0, Math.PI * 2, false);
    ctx.fillStyle = "green";
    ctx.fill();
    ctx.closePath();
  };

  const drawPaddle = () => {
    ctx.beginPath();
    ctx.rect(paddleX, canvas.height - paddleHeight, paddleWidth, paddleHeight);
    ctx.fillStyle = "#0095DD";
    ctx.fill();
    ctx.closePath();
  };

  const draw = () => {
    ctx.clearRect(0, 0, canvas.width, canvas.height);
    drawBall();
    drawPaddle();

    if (!(x <= canvas.width - ball_radius && x >= ball_radius)) {
      dx = -dx;
    }
    if (!(y <= canvas.height - ball_radius && y >= ball_radius)) {
      dy = -dy;
    }

    if (rightPressed && paddleX < canvas.width - paddleWidth) {
      paddleX += move_size;
    } else if (leftPressed && paddleX > 0) {
      paddleX -= move_size;
    }

    x += dx;
    y += dy;
  };

  const paddleHandler = (e, value) => {
    if (e.key === "Right" || e.key === "ArrowRight") {
      rightPressed = value;
    } else if (e.key === "Left" || e.key === "ArrowLeft") {
      leftPressed = value;
    }
  };

  const keyDownHandler = (e) => paddleHandler(e, true);
  const keyUpHandler = (e) => paddleHandler(e, false);

  window.addEventListener('resize', resizeCanvas, false);
  window.addEventListener("keydown", keyDownHandler, false);
  window.addEventListener("keyup", keyUpHandler, false);
  resizeCanvas();
  setInterval(draw, 20);
});
