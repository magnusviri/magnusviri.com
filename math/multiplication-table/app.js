"use strict";

const ROWS = 10;
const COLS = 10;
const CELL_SIZE = 60;
const MARGIN = 20;
const FONT_SIZE = 24;
const BUTTON_HEIGHT = 40;
const BUTTON_WIDTH = 120;
const BUTTON_GAP = 10;

const WIDTH = (COLS + 1) * CELL_SIZE + MARGIN * 2;
const HEIGHT =
  (ROWS + 1) * CELL_SIZE + MARGIN * 2 + BUTTON_HEIGHT + BUTTON_GAP * 2;

const canvas = document.getElementById("game");
const ctx = canvas.getContext("2d");

let rowOffset = 0;
let colOffset = 0;
let mouse = { x: -1, y: -1, inside: false };
let palette = {};

const buttons = {
  rowDec: {
    x: MARGIN,
    y: HEIGHT - BUTTON_HEIGHT - MARGIN,
    w: BUTTON_WIDTH,
    h: BUTTON_HEIGHT,
    label: "Rows - (W/↑)",
    action: () => {
      rowOffset -= 1;
    },
  },
  rowInc: {
    x: MARGIN + BUTTON_WIDTH + BUTTON_GAP,
    y: HEIGHT - BUTTON_HEIGHT - MARGIN,
    w: BUTTON_WIDTH,
    h: BUTTON_HEIGHT,
    label: "Rows + (S/↓)",
    action: () => {
      rowOffset += 1;
    },
  },
  colDec: {
    x: WIDTH - 2 * BUTTON_WIDTH - BUTTON_GAP - MARGIN,
    y: HEIGHT - BUTTON_HEIGHT - MARGIN,
    w: BUTTON_WIDTH,
    h: BUTTON_HEIGHT,
    label: "Cols - (A/←)",
    action: () => {
      colOffset -= 1;
    },
  },
  colInc: {
    x: WIDTH - BUTTON_WIDTH - MARGIN,
    y: HEIGHT - BUTTON_HEIGHT - MARGIN,
    w: BUTTON_WIDTH,
    h: BUTTON_HEIGHT,
    label: "Cols + (D/→)",
    action: () => {
      colOffset += 1;
    },
  },
};

function isPointInRect(point, rect) {
  return (
    point.x >= rect.x &&
    point.x <= rect.x + rect.w &&
    point.y >= rect.y &&
    point.y <= rect.y + rect.h
  );
}

function cssColor(name, fallback) {
  if (typeof getComputedStyle !== "function") {
    return fallback;
  }

  const source = document.documentElement || canvas;
  const value = getComputedStyle(source).getPropertyValue(name).trim();
  return value || fallback;
}

function updatePalette() {
  palette = {
    bg: cssColor("--canvas-bg", "rgb(30, 30, 30)"),
    grid: cssColor("--grid-color", "rgb(90, 90, 90)"),
    text: cssColor("--text-color", "rgb(240, 240, 240)"),
    headerRow: cssColor("--header-row-color", "rgb(60, 100, 160)"),
    headerCol: cssColor("--header-col-color", "rgb(80, 140, 90)"),
    square: cssColor("--square-color", "rgb(150, 120, 60)"),
    hover: cssColor("--hover-color", "rgb(70, 70, 120)"),
    button: cssColor("--button-color", "rgb(80, 80, 80)"),
    buttonHover: cssColor("--button-hover", "rgb(110, 110, 110)"),
  };
}

function getCanvasPoint(event) {
  const rect = canvas.getBoundingClientRect();
  return {
    x: ((event.clientX - rect.left) / rect.width) * canvas.width,
    y: ((event.clientY - rect.top) / rect.height) * canvas.height,
  };
}

function getCellUnderMouse() {
  if (!mouse.inside) {
    return { row: null, col: null };
  }

  const x = mouse.x - MARGIN;
  const y = mouse.y - MARGIN;

  if (x < 0 || y < 0) {
    return { row: null, col: null };
  }

  const col = Math.floor(x / CELL_SIZE);
  const row = Math.floor(y / CELL_SIZE);

  if (row > ROWS || col > COLS) {
    return { row: null, col: null };
  }

  return { row, col };
}

function drawRoundedRect(x, y, width, height, radius) {
  const r = Math.min(radius, width / 2, height / 2);
  ctx.beginPath();
  ctx.moveTo(x + r, y);
  ctx.lineTo(x + width - r, y);
  ctx.quadraticCurveTo(x + width, y, x + width, y + r);
  ctx.lineTo(x + width, y + height - r);
  ctx.quadraticCurveTo(x + width, y + height, x + width - r, y + height);
  ctx.lineTo(x + r, y + height);
  ctx.quadraticCurveTo(x, y + height, x, y + height - r);
  ctx.lineTo(x, y + r);
  ctx.quadraticCurveTo(x, y, x + r, y);
  ctx.closePath();
}

function drawCenteredText(text, x, y, size = FONT_SIZE) {
  ctx.fillStyle = palette.text;
  ctx.font = `${size}px Arial, sans-serif`;
  ctx.textAlign = "center";
  ctx.textBaseline = "middle";
  ctx.fillText(text, x, y);
}

function drawButton(button) {
  const hovered = mouse.inside && isPointInRect(mouse, button);
  drawRoundedRect(button.x, button.y, button.w, button.h, 6);
  ctx.fillStyle = hovered ? palette.buttonHover : palette.button;
  ctx.fill();
  ctx.lineWidth = 2;
  ctx.strokeStyle = palette.grid;
  ctx.stroke();
  drawCenteredText(
    button.label,
    button.x + button.w / 2,
    button.y + button.h / 2,
    18,
  );
}

function drawTable() {
  ctx.clearRect(0, 0, WIDTH, HEIGHT);
  ctx.fillStyle = palette.bg;
  ctx.fillRect(0, 0, WIDTH, HEIGHT);

  const hover = getCellUnderMouse();

  for (let row = 0; row <= ROWS; row += 1) {
    for (let col = 0; col <= COLS; col += 1) {
      const x = MARGIN + col * CELL_SIZE;
      const y = MARGIN + row * CELL_SIZE;
      let cellColor = palette.bg;

      if (row === 0 && col !== 0) {
        cellColor = palette.headerRow;
      } else if (col === 0 && row !== 0) {
        cellColor = palette.headerCol;
      } else if (row > 0 && col > 0) {
        const rowValue = row + rowOffset;
        const colValue = col + colOffset;

        if (rowValue === colValue) {
          cellColor = palette.square;
        } else if (hover.row !== null && (row === hover.row || col === hover.col)) {
          cellColor = palette.hover;
        }
      }

      ctx.fillStyle = cellColor;
      ctx.fillRect(x, y, CELL_SIZE, CELL_SIZE);
      ctx.lineWidth = 1;
      ctx.strokeStyle = palette.grid;
      ctx.strokeRect(x + 0.5, y + 0.5, CELL_SIZE, CELL_SIZE);

      let text = "";
      if (row === 0 && col !== 0) {
        text = String(col + colOffset);
      } else if (col === 0 && row !== 0) {
        text = String(row + rowOffset);
      } else if (row > 0 && col > 0) {
        text = String((row + rowOffset) * (col + colOffset));
      }

      if (text) {
        drawCenteredText(text, x + CELL_SIZE / 2, y + CELL_SIZE / 2);
      }
    }
  }

  Object.values(buttons).forEach(drawButton);
}

function handleOffsetKey(key) {
  if (key === "w" || key === "W" || key === "ArrowUp") {
    rowOffset -= 1;
    return true;
  }

  if (key === "s" || key === "S" || key === "ArrowDown") {
    rowOffset += 1;
    return true;
  }

  if (key === "a" || key === "A" || key === "ArrowLeft") {
    colOffset -= 1;
    return true;
  }

  if (key === "d" || key === "D" || key === "ArrowRight") {
    colOffset += 1;
    return true;
  }

  return false;
}

function animationLoop() {
  drawTable();
  requestAnimationFrame(animationLoop);
}

canvas.addEventListener("pointermove", (event) => {
  mouse = { ...getCanvasPoint(event), inside: true };
});

canvas.addEventListener("pointerleave", () => {
  mouse = { x: -1, y: -1, inside: false };
});

canvas.addEventListener("pointerdown", (event) => {
  canvas.focus();
  mouse = { ...getCanvasPoint(event), inside: true };
  for (const button of Object.values(buttons)) {
    if (isPointInRect(mouse, button)) {
      button.action();
      event.preventDefault();
      return;
    }
  }
});

window.addEventListener("keydown", (event) => {
  if (handleOffsetKey(event.key)) {
    event.preventDefault();
  }
});

if (typeof window.matchMedia === "function") {
  const colorSchemeQuery = window.matchMedia("(prefers-color-scheme: dark)");
  if (typeof colorSchemeQuery.addEventListener === "function") {
    colorSchemeQuery.addEventListener("change", updatePalette);
  } else if (typeof colorSchemeQuery.addListener === "function") {
    colorSchemeQuery.addListener(updatePalette);
  }
}

canvas.width = WIDTH;
canvas.height = HEIGHT;
canvas.focus();
updatePalette();
animationLoop();
