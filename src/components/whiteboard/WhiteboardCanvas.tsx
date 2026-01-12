import { useRef, useEffect, useState, useCallback } from 'react';
import { DrawingEvent } from '@/lib/whiteboardService';

export type DrawingTool = 'pen' | 'eraser' | 'text' | 'rect' | 'circle' | 'line';

interface WhiteboardCanvasProps {
  roomId: string;
  currentTool: DrawingTool;
  currentColor: string;
  strokeWidth: number;
  onDrawingEvent: (event: Omit<DrawingEvent, 'id' | 'created_at' | 'sequence_number' | 'room_id' | 'user_id'>) => void;
  remoteEvents: DrawingEvent[];
  canDraw: boolean;
}

interface Point {
  x: number;
  y: number;
}

export default function WhiteboardCanvas({
  currentTool,
  currentColor,
  strokeWidth,
  onDrawingEvent,
  remoteEvents,
  canDraw,
}: WhiteboardCanvasProps) {
  const canvasRef = useRef<HTMLCanvasElement>(null);
  const [isDrawing, setIsDrawing] = useState(false);
  const [currentPath, setCurrentPath] = useState<Point[]>([]);
  const [startPoint, setStartPoint] = useState<Point | null>(null);
  const [history, setHistory] = useState<ImageData[]>([]);
  const [historyStep, setHistoryStep] = useState(-1);

  // Initialize canvas
  useEffect(() => {
    const canvas = canvasRef.current;
    if (!canvas) return;

    const ctx = canvas.getContext('2d');
    if (!ctx) return;

    // Set canvas size
    const resizeCanvas = () => {
      const rect = canvas.getBoundingClientRect();
      canvas.width = rect.width;
      canvas.height = rect.height;
      
      // Fill with white background
      ctx.fillStyle = '#ffffff';
      ctx.fillRect(0, 0, canvas.width, canvas.height);
      
      // Save initial state
      saveToHistory();
    };

    resizeCanvas();
    window.addEventListener('resize', resizeCanvas);

    return () => window.removeEventListener('resize', resizeCanvas);
  }, []);

  // Save canvas state to history
  const saveToHistory = useCallback(() => {
    const canvas = canvasRef.current;
    if (!canvas) return;

    const ctx = canvas.getContext('2d');
    if (!ctx) return;

    const imageData = ctx.getImageData(0, 0, canvas.width, canvas.height);
    const newHistory = history.slice(0, historyStep + 1);
    newHistory.push(imageData);
    
    // Limit history to 50 steps
    if (newHistory.length > 50) {
      newHistory.shift();
    } else {
      setHistoryStep(historyStep + 1);
    }
    
    setHistory(newHistory);
  }, [history, historyStep]);

  // Undo
  const undo = useCallback(() => {
    if (historyStep > 0) {
      const canvas = canvasRef.current;
      if (!canvas) return;

      const ctx = canvas.getContext('2d');
      if (!ctx) return;

      const prevStep = historyStep - 1;
      ctx.putImageData(history[prevStep], 0, 0);
      setHistoryStep(prevStep);

      // Broadcast undo event
      onDrawingEvent({
        event_type: 'undo',
        event_data: {},
      });
    }
  }, [historyStep, history, onDrawingEvent]);

  // Clear canvas
  const clearCanvas = useCallback(() => {
    const canvas = canvasRef.current;
    if (!canvas) return;

    const ctx = canvas.getContext('2d');
    if (!ctx) return;

    ctx.fillStyle = '#ffffff';
    ctx.fillRect(0, 0, canvas.width, canvas.height);
    saveToHistory();

    // Broadcast clear event
    onDrawingEvent({
      event_type: 'clear',
      event_data: {},
    });
  }, [onDrawingEvent, saveToHistory]);

  // Get canvas coordinates from mouse event
  const getCanvasCoordinates = (e: React.MouseEvent<HTMLCanvasElement>): Point => {
    const canvas = canvasRef.current;
    if (!canvas) return { x: 0, y: 0 };

    const rect = canvas.getBoundingClientRect();
    return {
      x: e.clientX - rect.left,
      y: e.clientY - rect.top,
    };
  };

  // Handle mouse down
  const handleMouseDown = (e: React.MouseEvent<HTMLCanvasElement>) => {
    if (!canDraw) return;

    const point = getCanvasCoordinates(e);
    setIsDrawing(true);
    setStartPoint(point);

    if (currentTool === 'pen' || currentTool === 'eraser') {
      setCurrentPath([point]);
    }
  };

  // Handle mouse move
  const handleMouseMove = (e: React.MouseEvent<HTMLCanvasElement>) => {
    if (!canDraw || !isDrawing) return;

    const canvas = canvasRef.current;
    if (!canvas) return;

    const ctx = canvas.getContext('2d');
    if (!ctx) return;

    const point = getCanvasCoordinates(e);

    if (currentTool === 'pen' || currentTool === 'eraser') {
      const newPath = [...currentPath, point];
      setCurrentPath(newPath);

      // Draw locally
      ctx.strokeStyle = currentTool === 'eraser' ? '#ffffff' : currentColor;
      ctx.lineWidth = strokeWidth;
      ctx.lineCap = 'round';
      ctx.lineJoin = 'round';

      if (currentPath.length > 0) {
        ctx.beginPath();
        ctx.moveTo(currentPath[currentPath.length - 1].x, currentPath[currentPath.length - 1].y);
        ctx.lineTo(point.x, point.y);
        ctx.stroke();
      }
    } else if (startPoint) {
      // For shapes, redraw from history to show preview
      if (historyStep >= 0 && history[historyStep]) {
        ctx.putImageData(history[historyStep], 0, 0);
      }

      ctx.strokeStyle = currentColor;
      ctx.lineWidth = strokeWidth;

      switch (currentTool) {
        case 'rect':
          ctx.strokeRect(
            startPoint.x,
            startPoint.y,
            point.x - startPoint.x,
            point.y - startPoint.y
          );
          break;
        case 'circle': {
          const radius = Math.sqrt(
            Math.pow(point.x - startPoint.x, 2) + Math.pow(point.y - startPoint.y, 2)
          );
          ctx.beginPath();
          ctx.arc(startPoint.x, startPoint.y, radius, 0, 2 * Math.PI);
          ctx.stroke();
          break;
        }
        case 'line':
          ctx.beginPath();
          ctx.moveTo(startPoint.x, startPoint.y);
          ctx.lineTo(point.x, point.y);
          ctx.stroke();
          break;
      }
    }
  };

  // Handle mouse up
  const handleMouseUp = (e: React.MouseEvent<HTMLCanvasElement>) => {
    if (!canDraw || !isDrawing) return;

    const point = getCanvasCoordinates(e);
    setIsDrawing(false);

    if (currentTool === 'pen' || currentTool === 'eraser') {
      // Emit path event
      onDrawingEvent({
        event_type: currentTool === 'eraser' ? 'erase' : 'draw',
        event_data: {
          tool: currentTool,
          color: currentColor,
          strokeWidth,
          points: currentPath,
        },
      });
      setCurrentPath([]);
    } else if (startPoint) {
      // Emit shape event
      onDrawingEvent({
        event_type: 'shape',
        event_data: {
          shape: currentTool,
          color: currentColor,
          strokeWidth,
          x: startPoint.x,
          y: startPoint.y,
          width: point.x - startPoint.x,
          height: point.y - startPoint.y,
        },
      });
    }

    saveToHistory();
    setStartPoint(null);
  };

  // Render remote drawing events
  useEffect(() => {
    if (remoteEvents.length === 0) return;

    const canvas = canvasRef.current;
    if (!canvas) return;

    const ctx = canvas.getContext('2d');
    if (!ctx) return;

    const latestEvent = remoteEvents[remoteEvents.length - 1];
    const { event_type, event_data } = latestEvent;

    switch (event_type) {
      case 'draw':
      case 'erase': {
        const points = event_data.points as Point[];
        if (points && points.length > 1) {
          ctx.strokeStyle = event_type === 'erase' ? '#ffffff' : (event_data.color || '#000000');
          ctx.lineWidth = event_data.strokeWidth || 2;
          ctx.lineCap = 'round';
          ctx.lineJoin = 'round';

          ctx.beginPath();
          ctx.moveTo(points[0].x, points[0].y);
          for (let i = 1; i < points.length; i++) {
            ctx.lineTo(points[i].x, points[i].y);
          }
          ctx.stroke();
        }
        break;
      }
      case 'shape': {
        ctx.strokeStyle = event_data.color || '#000000';
        ctx.lineWidth = event_data.strokeWidth || 2;

        const { shape, x = 0, y = 0, width = 0, height = 0 } = event_data;

        switch (shape) {
          case 'rect':
            ctx.strokeRect(x, y, width, height);
            break;
          case 'circle': {
            const radius = Math.sqrt(width * width + height * height);
            ctx.beginPath();
            ctx.arc(x, y, radius, 0, 2 * Math.PI);
            ctx.stroke();
            break;
          }
          case 'line':
            ctx.beginPath();
            ctx.moveTo(x, y);
            ctx.lineTo(x + width, y + height);
            ctx.stroke();
            break;
        }
        break;
      }
      case 'clear':
        ctx.fillStyle = '#ffffff';
        ctx.fillRect(0, 0, canvas.width, canvas.height);
        break;
    }

    saveToHistory();
  }, [remoteEvents, saveToHistory]);

  // Expose undo and clear functions
  useEffect(() => {
    // Store functions on window for external access if needed
    (window as any).whiteboardUndo = undo;
    (window as any).whiteboardClear = clearCanvas;
  }, [undo, clearCanvas]);

  return (
    <canvas
      ref={canvasRef}
      className="w-full h-full border border-border rounded-lg bg-white cursor-crosshair"
      onMouseDown={handleMouseDown}
      onMouseMove={handleMouseMove}
      onMouseUp={handleMouseUp}
      onMouseLeave={() => {
        if (isDrawing) {
          handleMouseUp({} as React.MouseEvent<HTMLCanvasElement>);
        }
      }}
    />
  );
}
