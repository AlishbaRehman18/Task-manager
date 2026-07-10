import React, { useState } from "react";
import { Plus, X, Flag, Calendar, Trash2 } from "lucide-react";

const COLUMNS = [
  { id: "todo", label: "To do", accent: "#8CA089" },
  { id: "doing", label: "Doing", accent: "#C97A2B" },
  { id: "done", label: "Done", accent: "#6B7A93" },
];

const PRIORITIES = {
  low: { label: "Low", color: "#6B7A93" },
  medium: { label: "Medium", color: "#C97A2B" },
  high: { label: "High", color: "#B5442E" },
};

let nextId = 4;

const initialTasks = [
  { id: 1, title: "Sketch onboarding flow", notes: "Rough wireframes, no polish needed yet.", priority: "medium", due: "2026-07-14", status: "todo" },
  { id: 2, title: "Fix login redirect bug", notes: "Users land on 404 after SSO callback.", priority: "high", due: "2026-07-12", status: "doing" },
  { id: 3, title: "Write release notes", notes: "Summarize v2.3 changes for the team.", priority: "low", due: "2026-07-10", status: "done" },
];

function EmptyDropZone({ label }) {
  return (
    <div
      style={{
        border: "1px dashed #C9C3B4",
        borderRadius: 4,
        padding: "20px 12px",
        textAlign: "center",
        color: "#8B8677",
        fontSize: 13,
        fontFamily: "Inter, system-ui, sans-serif",
      }}
    >
      Drag a card here, or add one to "{label}".
    </div>
  );
}

function TaskCard({ task, onMove, onDelete, columnIndex }) {
  const p = PRIORITIES[task.priority];
  const isDone = task.status === "done";

  return (
    <div
      style={{
        position: "relative",
        background: "#FFFFFF",
        borderRadius: "2px 2px 6px 6px",
        boxShadow: "0 1px 2px rgba(42,46,39,0.08), 0 1px 0 rgba(42,46,39,0.04)",
        marginBottom: 14,
        overflow: "hidden",
        opacity: isDone ? 0.72 : 1,
      }}
    >
      <div style={{ height: 5, background: p.color }} />
      <div style={{ padding: "14px 16px 12px" }}>
        <div style={{ display: "flex", justifyContent: "space-between", alignItems: "flex-start", gap: 8 }}>
          <h3
            style={{
              fontFamily: "Georgia, 'Times New Roman', serif",
              fontSize: 16,
              fontWeight: 700,
              color: "#2A2E27",
              margin: 0,
              lineHeight: 1.35,
              textDecoration: isDone ? "line-through" : "none",
            }}
          >
            {task.title}
          </h3>
          <button
            onClick={() => onDelete(task.id)}
            aria-label="Delete task"
            style={{
              background: "none",
              border: "none",
              cursor: "pointer",
              color: "#B0AB9B",
              padding: 2,
              flexShrink: 0,
            }}
          >
            <Trash2 size={15} />
          </button>
        </div>

        {task.notes && (
          <p
            style={{
              fontFamily: "Inter, system-ui, sans-serif",
              fontSize: 13,
              color: "#6B6A5F",
              margin: "6px 0 0",
              lineHeight: 1.5,
            }}
          >
            {task.notes}
          </p>
        )}

        <div style={{ display: "flex", alignItems: "center", gap: 12, marginTop: 12 }}>
          <span
            style={{
              display: "inline-flex",
              alignItems: "center",
              gap: 4,
              fontFamily: "SFMono-Regular, Menlo, Consolas, monospace",
              fontSize: 11,
              color: p.color,
              border: `1px solid ${p.color}55`,
              borderRadius: 3,
              padding: "2px 6px",
            }}
          >
            <Flag size={11} />
            {p.label}
          </span>
          {task.due && (
            <span
              style={{
                display: "inline-flex",
                alignItems: "center",
                gap: 4,
                fontFamily: "SFMono-Regular, Menlo, Consolas, monospace",
                fontSize: 11,
                color: "#8B8677",
              }}
            >
              <Calendar size={11} />
              {task.due}
            </span>
          )}
        </div>

        <div style={{ display: "flex", gap: 6, marginTop: 12 }}>
          {COLUMNS.filter((c) => c.id !== task.status).map((c) => (
            <button
              key={c.id}
              onClick={() => onMove(task.id, c.id)}
              style={{
                fontFamily: "Inter, system-ui, sans-serif",
                fontSize: 11,
                color: "#4A4E44",
                background: "#F3F0E8",
                border: "none",
                borderRadius: 3,
                padding: "4px 8px",
                cursor: "pointer",
              }}
            >
              Move to {c.label}
            </button>
          ))}
        </div>
      </div>

      {isDone && (
        <div
          aria-hidden="true"
          style={{
            position: "absolute",
            top: 10,
            right: -22,
            transform: "rotate(18deg)",
            fontFamily: "Georgia, serif",
            fontWeight: 700,
            fontSize: 11,
            letterSpacing: 2,
            color: "#6B7A93",
            border: "2px solid #6B7A93",
            borderRadius: 3,
            padding: "1px 24px",
            opacity: 0.55,
          }}
        >
          DONE
        </div>
      )}
    </div>
  );
}

function NewTaskForm({ onAdd, onClose }) {
  const [title, setTitle] = useState("");
  const [notes, setNotes] = useState("");
  const [priority, setPriority] = useState("medium");
  const [due, setDue] = useState("");

  const submit = (e) => {
    e.preventDefault();
    if (!title.trim()) return;
    onAdd({ title: title.trim(), notes: notes.trim(), priority, due });
    onClose();
  };

  const inputStyle = {
    width: "100%",
    fontFamily: "Inter, system-ui, sans-serif",
    fontSize: 13,
    padding: "8px 10px",
    borderRadius: 4,
    border: "1px solid #D9D4C6",
    marginTop: 4,
    marginBottom: 12,
    boxSizing: "border-box",
    background: "#FDFCF9",
    color: "#2A2E27",
  };

  const labelStyle = {
    fontFamily: "Inter, system-ui, sans-serif",
    fontSize: 12,
    color: "#6B6A5F",
    fontWeight: 600,
  };

  return (
    <div
      style={{
        position: "fixed",
        inset: 0,
        background: "rgba(42,46,39,0.35)",
        display: "flex",
        alignItems: "center",
        justifyContent: "center",
        zIndex: 50,
        padding: 16,
      }}
      onClick={onClose}
    >
      <form
        onSubmit={submit}
        onClick={(e) => e.stopPropagation()}
        style={{
          background: "#FFFFFF",
          borderRadius: 8,
          padding: 24,
          width: 380,
          maxWidth: "100%",
          boxShadow: "0 12px 32px rgba(42,46,39,0.25)",
        }}
      >
        <div style={{ display: "flex", justifyContent: "space-between", alignItems: "center", marginBottom: 16 }}>
          <h2 style={{ fontFamily: "Georgia, serif", fontSize: 18, margin: 0, color: "#2A2E27" }}>New task</h2>
          <button
            type="button"
            onClick={onClose}
            aria-label="Close"
            style={{ background: "none", border: "none", cursor: "pointer", color: "#8B8677" }}
          >
            <X size={18} />
          </button>
        </div>

        <label style={labelStyle}>Title</label>
        <input
          autoFocus
          style={inputStyle}
          value={title}
          onChange={(e) => setTitle(e.target.value)}
          placeholder="What needs doing?"
        />

        <label style={labelStyle}>Notes</label>
        <textarea
          style={{ ...inputStyle, minHeight: 60, resize: "vertical" }}
          value={notes}
          onChange={(e) => setNotes(e.target.value)}
          placeholder="Optional details"
        />

        <div style={{ display: "flex", gap: 12 }}>
          <div style={{ flex: 1 }}>
            <label style={labelStyle}>Priority</label>
            <select style={inputStyle} value={priority} onChange={(e) => setPriority(e.target.value)}>
              {Object.entries(PRIORITIES).map(([key, p]) => (
                <option key={key} value={key}>
                  {p.label}
                </option>
              ))}
            </select>
          </div>
          <div style={{ flex: 1 }}>
            <label style={labelStyle}>Due date</label>
            <input type="date" style={inputStyle} value={due} onChange={(e) => setDue(e.target.value)} />
          </div>
        </div>

        <button
          type="submit"
          style={{
            width: "100%",
            fontFamily: "Inter, system-ui, sans-serif",
            fontSize: 14,
            fontWeight: 600,
            color: "#FFFFFF",
            background: "#4A4E44",
            border: "none",
            borderRadius: 5,
            padding: "10px 0",
            cursor: "pointer",
            marginTop: 4,
          }}
        >
          Add task
        </button>
      </form>
    </div>
  );
}

export default function TaskManager() {
  const [tasks, setTasks] = useState(initialTasks);
  const [showForm, setShowForm] = useState(false);

  const addTask = (data) => {
    setTasks((prev) => [...prev, { id: nextId++, status: "todo", ...data }]);
  };

  const moveTask = (id, status) => {
    setTasks((prev) => prev.map((t) => (t.id === id ? { ...t, status } : t)));
  };

  const deleteTask = (id) => {
    setTasks((prev) => prev.filter((t) => t.id !== id));
  };

  return (
    <div
      style={{
        minHeight: "100vh",
        background: "#EDEAE1",
        padding: "32px 24px 60px",
        fontFamily: "Inter, system-ui, sans-serif",
      }}
    >
      <div style={{ maxWidth: 960, margin: "0 auto" }}>
        <div style={{ display: "flex", justifyContent: "space-between", alignItems: "flex-end", marginBottom: 28, flexWrap: "wrap", gap: 12 }}>
          <div>
            <p style={{ fontFamily: "SFMono-Regular, Menlo, monospace", fontSize: 11, letterSpacing: 2, color: "#8B8677", margin: "0 0 4px", textTransform: "uppercase" }}>
              Field notes / task board
            </p>
            <h1 style={{ fontFamily: "Georgia, 'Times New Roman', serif", fontSize: 30, color: "#2A2E27", margin: 0 }}>
              Docket
            </h1>
          </div>
          <button
            onClick={() => setShowForm(true)}
            style={{
              display: "inline-flex",
              alignItems: "center",
              gap: 6,
              fontSize: 14,
              fontWeight: 600,
              color: "#FFFFFF",
              background: "#4A4E44",
              border: "none",
              borderRadius: 5,
              padding: "10px 16px",
              cursor: "pointer",
            }}
          >
            <Plus size={16} />
            Add task
          </button>
        </div>

        <div
          style={{
            display: "grid",
            gridTemplateColumns: "repeat(auto-fit, minmax(240px, 1fr))",
            gap: 20,
          }}
        >
          {COLUMNS.map((col, i) => {
            const colTasks = tasks.filter((t) => t.status === col.id);
            return (
              <div key={col.id}>
                <div style={{ display: "flex", alignItems: "center", gap: 8, marginBottom: 14 }}>
                  <span style={{ width: 8, height: 8, borderRadius: "50%", background: col.accent, display: "inline-block" }} />
                  <h2 style={{ fontFamily: "Georgia, serif", fontSize: 15, fontWeight: 700, color: "#2A2E27", margin: 0 }}>
                    {col.label}
                  </h2>
                  <span style={{ fontFamily: "SFMono-Regular, Menlo, monospace", fontSize: 12, color: "#8B8677" }}>
                    {colTasks.length}
                  </span>
                </div>
                {colTasks.length === 0 ? (
                  <EmptyDropZone label={col.label} />
                ) : (
                  colTasks.map((task) => (
                    <TaskCard key={task.id} task={task} onMove={moveTask} onDelete={deleteTask} columnIndex={i} />
                  ))
                )}
              </div>
            );
          })}
        </div>
      </div>

      {showForm && <NewTaskForm onAdd={addTask} onClose={() => setShowForm(false)} />}
    </div>
  );
}