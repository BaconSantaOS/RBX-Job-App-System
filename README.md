# Roblox Job Application System

## 📌 Introduction

This project is a **complete Job Application System for Roblox**, designed to work across **two separate games** while remaining simple for developers to set up and customize.

The goal of this system is to allow players to apply for staff or job roles in a **dedicated Job Application game**, and then automatically receive their rank in the **main game** once approved — without admins needing to manually rank anyone.

The system is built to be **modular, scalable, and beginner‑friendly**, while still being powerful enough for professional games.

---

## 🧠 How the System Works (High‑Level Overview)

### 1️⃣ Job Application Game

Players join a separate game dedicated only to applications.

When they join:

* A **modern, animated, themed UI** opens automatically
* Players answer a set of application questions
* Questions can be:

  * Multiple‑choice (button based)
  * Text‑based (typed answers)
* Each question has its own score value

Once the player finishes the application:

* Their total score is calculated
* If they meet or exceed the required score, they **pass**
* Passing players are awarded a **badge**

The Job Application game does **not** permanently rank players. Instead, it only awards a badge, which acts as proof that the player passed.

---

### 2️⃣ Main Game (Automatic Ranking)

When a player joins the **main game**:

* The game automatically checks whether the player owns the application badge
* If the badge is detected, the player is instantly ranked using **HD Admin**
* The rank is applied **permanently**, meaning it persists across servers and rejoins

This means:

* No admin commands are required
* No manual reviews are needed
* Players only need to pass the application once

---

## ⭐ Why This System Is Useful

* Prevents abuse by separating applications from the main game
* Uses Roblox badges for secure cross‑game verification
* Fully automated ranking with HD Admin
* Easy to update questions without rewriting UI or logic
* Clean, professional workflow used in real staff systems

---

## 🎯 Intended Use Cases

* Staff applications (Moderators, Admins, Helpers)
* Group job applications
* Training or qualification systems
* Any role that should require approval before ranking

---

## 🚀 Final Notes

This system is designed to be **customizable**, **expandable**, and **safe**.

Developers can:

* Change questions at any time
* Adjust pass requirements
* Switch UI themes
* Control which ranks are granted

All without modifying the core logic.

Enjoy building with it!
