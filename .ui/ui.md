\# Design Export Context



\- Generated at: `2026-06-20T13:13:08.938Z`

\- Document ID: `27365293-7435-432b-9172-66edfd1516f0`

\- Page count: 9



\## Original Prompt



```text

\# APP: Life Tracker — Offline Minimalist Habit, Goal \& Counter Tracker



\## App Type \& Platform

A minimalist, offline-first Android-focused mobile app (also usable on iOS) for personal tracking: habits, goals, counters, and timed activities. Clean, calm, distraction-free visual design — think Notion meets a habit tracker. Support both Light and Dark mode with a true black/dark gray dark theme (not just dimmed colors).



\## Data \& Storage — IMPORTANT

Do NOT use Firebase or any cloud backend. This app is fully offline-first. Use local on-device storage:

\- Use SQLite (via FlutterFlow's local database / sqflite custom code) as the primary persistent store, OR Hive if SQLite isn't natively supported — whichever FlutterFlow's local DB tooling supports best.

\- All trackers, logs, categories, and settings must be stored locally and persist across app restarts with zero network dependency.

\- No login, no auth, no user accounts. Single local user.

\- Use App State / local DB for global variables like "current streak," "today's progress," and "selected theme."



\## Core Data Models

1\. \*\*Tracker\*\* (the central entity)

&#x20;  - id, name, icon, color, category\_id, type (enum: Habit, Goal, Counter, Timer)

&#x20;  - target\_value (for Goal/Counter — e.g. 8 glasses, 30 pages)

&#x20;  - unit (e.g. "glasses," "pages," "minutes," "kcal")

&#x20;  - frequency (Daily, Weekly, Custom days)

&#x20;  - reminder\_time(s) (one or more local notification times)

&#x20;  - created\_at, is\_archived



2\. \*\*TrackerLog\*\* (each completion/entry)

&#x20;  - id, tracker\_id, date, value\_logged, timestamp, note (optional)



3\. \*\*Category\*\*

&#x20;  - id, name, icon, color (e.g. Health, Productivity, Mindfulness, Fitness, Nutrition)



4\. \*\*Streak\*\* (derived/calculated, can be computed from TrackerLog rather than stored)

&#x20;  - current\_streak, longest\_streak, last\_completed\_date



5\. \*\*NutritionEntry\*\* (for calorie/nutrition tracking specifically)

&#x20;  - id, date, meal\_type, food\_name, calories, protein, carbs, fat



6\. \*\*AppSettings\*\*

&#x20;  - theme\_mode (light/dark/system), default\_reminder\_time, week\_start\_day



\## Screens \& Navigation



\### 1. Splash Screen

Minimal logo/wordmark, auto-navigates to Dashboard after 1.5s (no auth check needed).



\### 2. Dashboard (Home) — bottom nav tab 1

\- Today's date header with day streak summary at top (e.g. "🔥 12 day streak")

\- Horizontal scrollable category filter chips

\- Vertical list of today's trackers as cards:

&#x20; - Habit cards: checkbox/checkmark toggle for "done today," small streak flame icon

&#x20; - Counter cards: stepper (+/-) with progress bar toward target (e.g. "5/8 glasses")

&#x20; - Goal cards: progress bar with percentage and days remaining

&#x20; - Timer cards: a "Start Timer" button showing today's logged duration

\- Circular progress ring at top showing "X of Y trackers completed today"

\- Floating Action Button (+) to add a new tracker



\### 3. Add/Edit Tracker Screen

\- Tracker type selector (segmented control): Habit | Goal | Counter | Timer

\- Name input, icon picker, color picker

\- Category dropdown (with "+ create new category" inline option)

\- Conditional fields based on type:

&#x20; - Habit: frequency selector (daily/specific weekdays)

&#x20; - Goal: target value, unit, deadline date picker

&#x20; - Counter: target value, unit, increment step size

&#x20; - Timer: target duration, session type

\- Reminder section: toggle + time picker(s), supports multiple reminders per tracker

\- Save / Cancel buttons



\### 4. Tracker Detail Screen

\- Header with tracker name, icon, color, edit/delete icons

\- Big stat row: current streak, longest streak, completion rate %

\- Calendar heatmap view (GitHub-style contribution grid) showing last 90 days of activity

\- Line/bar graph (use FlutterFlow charts widget) showing trend over selectable range: 7D / 30D / 90D / All

\- Activity history list below — chronological log entries with date, value, optional note

\- Quick action button matching type (Log Now / Start Timer / Mark Done)



\### 5. Timer Tracking Screen (for Timer-type trackers)

\- Large circular timer display (MM:SS)

\- Start / Pause / Stop controls

\- On stop: auto-saves session to TrackerLog with duration

\- Shows today's cumulative time and weekly total below



\### 6. Categories Screen — bottom nav tab 2

\- Grid or list of all categories with tracker count per category

\- Tap category → filtered list of trackers in that category

\- Add/edit/delete category (icon + color + name)



\### 7. Analytics/Insights Screen — bottom nav tab 3

\- Top summary cards: Total active trackers, Best streak overall, Weekly completion rate

\- Per-category breakdown bar chart

\- Tracker comparison: multi-select trackers to overlay trend lines

\- Best/worst performing trackers list (highest vs lowest completion %)

\- Date range filter (This Week / This Month / Custom)



\### 8. Nutrition/Calorie Tracker Screen (specialized sub-module)

\- Daily calorie summary ring (consumed vs. goal)

\- Macro breakdown (protein/carbs/fat) as horizontal progress bars

\- Meal sections: Breakfast / Lunch / Dinner / Snacks, each with "+ Add food" 

\- Simple food entry form: name, calories, macros (manual entry, no external API)

\- Daily/weekly calorie trend line chart



\### 9. Settings Screen — bottom nav tab 4

\- Theme toggle: Light / Dark / System

\- Default reminder time

\- Week start day (Sunday/Monday)

\- Data management: Export data (to local JSON/CSV file), Clear all data (with confirmation dialog)

\- About/version info



\## Reminders \& Notifications

\- Use FlutterFlow's local notification scheduling (flutter\_local\_notifications) — NOT push notifications, since this is fully offline.

\- Support per-tracker custom reminder times, daily recurring, and one-off custom dates.

\- Notification tap should deep-link into that tracker's detail screen.



\## UI/Visual Style Guidelines

\- Minimalist, generous whitespace, rounded cards (12-16px radius), soft shadows in light mode / subtle borders in dark mode

\- Primary accent color: a calm teal or muted indigo (avoid aggressive reds/oranges except for streak fire icons)

\- Typography: clean sans-serif, clear hierarchy (large numbers for stats, medium for labels)

\- Icons: outline-style icon set, consistent stroke width

\- Use FlutterFlow's built-in chart widgets for graphs (line chart for trends, bar chart for comparisons, custom widget/painter for the calendar heatmap if not natively supported)

\- Smooth micro-interactions: checkbox tick animation, progress bar fill animation, streak counter increment animation



\## Navigation Structure

Bottom Navigation Bar with 4 tabs: Dashboard | Categories | Analytics | Settings

Floating Action Button on Dashboard for quick "Add Tracker"

Tracker cards on Dashboard navigate to Tracker Detail on tap



\## Non-Functional Requirements

\- App must function fully with airplane mode on / no internet permission requested

\- All CRUD operations (create/edit/delete trackers, categories, logs) happen against local DB only

\- Data persists across app restarts and updates

\- Support data export as backup (local file, JSON or CSV) since there's no cloud sync

```



\## Theme (JSON)



```json

{

&#x20; "schema\_version": 2,

&#x20; "fonts": {

&#x20;   "primary": "google:Plus Jakarta Sans",

&#x20;   "secondary": "google:Inter",

&#x20;   "mono": "google:Space Grotesk"

&#x20; },

&#x20; "colors": {

&#x20;   "light": {

&#x20;     "primary": "#0F766E",

&#x20;     "on\_primary": "#FFFFFF",

&#x20;     "primary\_container": "#0F766E1A",

&#x20;     "on\_primary\_container": "#1C1917",

&#x20;     "secondary": "#57534E",

&#x20;     "on\_secondary": "#FFFFFF",

&#x20;     "secondary\_container": "#57534E1A",

&#x20;     "on\_secondary\_container": "#1C1917",

&#x20;     "accent": "#0D9488",

&#x20;     "on\_accent": "#FFFFFF",

&#x20;     "accent\_container": "#0D94881A",

&#x20;     "on\_accent\_container": "#1C1917",

&#x20;     "background": "#FAFAF9",

&#x20;     "on\_background": "#1C1917",

&#x20;     "secondary\_background": "#F5F5F4",

&#x20;     "surface": "#FFFFFF",

&#x20;     "on\_surface": "#1C1917",

&#x20;     "surface\_variant": "#E7E5E4",

&#x20;     "on\_surface\_variant": "#57534E",

&#x20;     "primary\_text": "#1C1917",

&#x20;     "secondary\_text": "#57534E",

&#x20;     "hint": "#A8A29E",

&#x20;     "outline": "#D6D3D1",

&#x20;     "divider": "#E7E5E4",

&#x20;     "success": "#16A34A",

&#x20;     "on\_success": "#FFFFFF",

&#x20;     "warning": "#CA8A04",

&#x20;     "on\_warning": "#FFFFFF",

&#x20;     "error": "#DC2626",

&#x20;     "on\_error": "#FFFFFF",

&#x20;     "info": "#2563EB",

&#x20;     "on\_info": "#FFFFFF",

&#x20;     "transparent": "#00000000",

&#x20;     "full\_contrast": "#000000"

&#x20;   },

&#x20;   "dark": {

&#x20;     "primary": "#5EEAD4",

&#x20;     "on\_primary": "#000000",

&#x20;     "primary\_container": "#5EEAD424",

&#x20;     "on\_primary\_container": "#FAFAF9",

&#x20;     "secondary": "#D6D3D1",

&#x20;     "on\_secondary": "#000000",

&#x20;     "secondary\_container": "#D6D3D124",

&#x20;     "on\_secondary\_container": "#FAFAF9",

&#x20;     "accent": "#2DD4BF",

&#x20;     "on\_accent": "#FFFFFF",

&#x20;     "accent\_container": "#2DD4BF24",

&#x20;     "on\_accent\_container": "#FAFAF9",

&#x20;     "background": "#000000",

&#x20;     "on\_background": "#FAFAF9",

&#x20;     "secondary\_background": "#0C0C0C",

&#x20;     "surface": "#18181B",

&#x20;     "on\_surface": "#FAFAF9",

&#x20;     "surface\_variant": "#27272A",

&#x20;     "on\_surface\_variant": "#A8A29E",

&#x20;     "primary\_text": "#FAFAF9",

&#x20;     "secondary\_text": "#A8A29E",

&#x20;     "hint": "#52525B",

&#x20;     "outline": "#3F3F46",

&#x20;     "divider": "#27272A",

&#x20;     "success": "#22C55E",

&#x20;     "on\_success": "#FFFFFF",

&#x20;     "warning": "#EAB308",

&#x20;     "on\_warning": "#FFFFFF",

&#x20;     "error": "#F87171",

&#x20;     "on\_error": "#FFFFFF",

&#x20;     "info": "#60A5FA",

&#x20;     "on\_info": "#FFFFFF",

&#x20;     "transparent": "#00000000",

&#x20;     "full\_contrast": "#FFFFFF"

&#x20;   }

&#x20; },

&#x20; "text\_styles": {

&#x20;   "display\_large": {

&#x20;     "font": "primary",

&#x20;     "size": 57,

&#x20;     "weight": 700,

&#x20;     "height": 1.1

&#x20;   },

&#x20;   "display\_medium": {

&#x20;     "font": "primary",

&#x20;     "size": 45,

&#x20;     "weight": 700,

&#x20;     "height": 1.2

&#x20;   },

&#x20;   "display\_small": {

&#x20;     "font": "primary",

&#x20;     "size": 36,

&#x20;     "weight": 600,

&#x20;     "height": 1.2

&#x20;   },

&#x20;   "headline\_large": {

&#x20;     "font": "primary",

&#x20;     "size": 32,

&#x20;     "weight": 700,

&#x20;     "height": 1.2

&#x20;   },

&#x20;   "headline\_medium": {

&#x20;     "font": "primary",

&#x20;     "size": 28,

&#x20;     "weight": 600,

&#x20;     "height": 1.25

&#x20;   },

&#x20;   "headline\_small": {

&#x20;     "font": "primary",

&#x20;     "size": 24,

&#x20;     "weight": 600,

&#x20;     "height": 1.3

&#x20;   },

&#x20;   "title\_large": {

&#x20;     "font": "primary",

&#x20;     "size": 22,

&#x20;     "weight": 600,

&#x20;     "height": 1.25

&#x20;   },

&#x20;   "title\_medium": {

&#x20;     "font": "primary",

&#x20;     "size": 16,

&#x20;     "weight": 600,

&#x20;     "height": 1.4

&#x20;   },

&#x20;   "title\_small": {

&#x20;     "font": "primary",

&#x20;     "size": 14,

&#x20;     "weight": 600,

&#x20;     "height": 1.4

&#x20;   },

&#x20;   "body\_large": {

&#x20;     "font": "secondary",

&#x20;     "size": 16,

&#x20;     "weight": 400,

&#x20;     "height": 1.5

&#x20;   },

&#x20;   "body\_medium": {

&#x20;     "font": "secondary",

&#x20;     "size": 14,

&#x20;     "weight": 400,

&#x20;     "height": 1.5

&#x20;   },

&#x20;   "body\_small": {

&#x20;     "font": "secondary",

&#x20;     "size": 12,

&#x20;     "weight": 400,

&#x20;     "height": 1.4

&#x20;   },

&#x20;   "label\_large": {

&#x20;     "font": "secondary",

&#x20;     "size": 14,

&#x20;     "weight": 600,

&#x20;     "height": 1.3

&#x20;   },

&#x20;   "label\_medium": {

&#x20;     "font": "secondary",

&#x20;     "size": 12,

&#x20;     "weight": 600,

&#x20;     "height": 1.3

&#x20;   },

&#x20;   "label\_small": {

&#x20;     "font": "secondary",

&#x20;     "size": 11,

&#x20;     "weight": 600,

&#x20;     "height": 1.2

&#x20;   }

&#x20; },

&#x20; "spacing": {

&#x20;   "none": 0,

&#x20;   "xs": 4,

&#x20;   "sm": 8,

&#x20;   "md": 16,

&#x20;   "lg": 24,

&#x20;   "xl": 32,

&#x20;   "xxl": 48,

&#x20;   "xxxl": 64

&#x20; },

&#x20; "radii": {

&#x20;   "none": 0,

&#x20;   "xs": 4,

&#x20;   "sm": 8,

&#x20;   "md": 12,

&#x20;   "lg": 16,

&#x20;   "xl": 24,

&#x20;   "xxl": 32,

&#x20;   "full": 9999

&#x20; },

&#x20; "shadows": {

&#x20;   "none": {

&#x20;     "color": "#00000000",

&#x20;     "dx": 0,

&#x20;     "dy": 0,

&#x20;     "blur": 0,

&#x20;     "spread": 0

&#x20;   },

&#x20;   "xs": {

&#x20;     "color": "#00000008",

&#x20;     "dx": 0,

&#x20;     "dy": 1,

&#x20;     "blur": 2,

&#x20;     "spread": 0

&#x20;   },

&#x20;   "sm": {

&#x20;     "color": "#0000000A",

&#x20;     "dx": 0,

&#x20;     "dy": 2,

&#x20;     "blur": 4,

&#x20;     "spread": 0

&#x20;   },

&#x20;   "md": {

&#x20;     "color": "#0000000F",

&#x20;     "dx": 0,

&#x20;     "dy": 4,

&#x20;     "blur": 8,

&#x20;     "spread": 0

&#x20;   },

&#x20;   "lg": {

&#x20;     "color": "#00000014",

&#x20;     "dx": 0,

&#x20;     "dy": 8,

&#x20;     "blur": 16,

&#x20;     "spread": 0

&#x20;   },

&#x20;   "xl": {

&#x20;     "color": "#0000001A",

&#x20;     "dx": 0,

&#x20;     "dy": 12,

&#x20;     "blur": 24,

&#x20;     "spread": 0

&#x20;   },

&#x20;   "xxl": {

&#x20;     "color": "#00000026",

&#x20;     "dx": 0,

&#x20;     "dy": 16,

&#x20;     "blur": 32,

&#x20;     "spread": 0

&#x20;   }

&#x20; },

&#x20; "gradients": {}

}

```



\## Pages



\### 1. Splash Screen



\- Frame ID: `frame1`

\- Original page prompt: "Minimalist branding screen with a wordmark that auto-transitions to the dashboard."

\- Follow-up prompts: \_None\_



\#### DslDocument (JSON)



```json

{

&#x20; "root": {

&#x20;   "type": "scaffold",

&#x20;   "properties": {

&#x20;     "bg": {

&#x20;       "color": {

&#x20;         "color": "background"

&#x20;       }

&#x20;     },

&#x20;     "safe\_area": {

&#x20;       "boolVal": {

&#x20;         "value": true

&#x20;       }

&#x20;     }

&#x20;   },

&#x20;   "children": \[

&#x20;     {

&#x20;       "type": "stack",

&#x20;       "properties": {

&#x20;         "fit": {

&#x20;           "stringVal": {

&#x20;             "value": "expand"

&#x20;           }

&#x20;         }

&#x20;       },

&#x20;       "children": \[

&#x20;         {

&#x20;           "type": "container",

&#x20;           "properties": {

&#x20;             "gradient": {

&#x20;               "gradient": {

&#x20;                 "type": "GRADIENT\_TYPE\_RADIAL",

&#x20;                 "direction": "center",

&#x20;                 "stops": \[

&#x20;                   {

&#x20;                     "color": "surface"

&#x20;                   },

&#x20;                   {

&#x20;                     "color": "background"

&#x20;                   }

&#x20;                 ]

&#x20;               }

&#x20;             }

&#x20;           },

&#x20;           "editorId": "container21"

&#x20;         },

&#x20;         {

&#x20;           "type": "center",

&#x20;           "children": \[

&#x20;             {

&#x20;               "type": "column",

&#x20;               "properties": {

&#x20;                 "spacing": {

&#x20;                   "stringVal": {

&#x20;                     "value": "xl"

&#x20;                   }

&#x20;                 },

&#x20;                 "main\_size": {

&#x20;                   "stringVal": {

&#x20;                     "value": "min"

&#x20;                   }

&#x20;                 }

&#x20;               },

&#x20;               "children": \[

&#x20;                 {

&#x20;                   "type": "container",

&#x20;                   "properties": {

&#x20;                     "width": {

&#x20;                       "px": {

&#x20;                         "value": 120,

&#x20;                         "isInfinity": false

&#x20;                       }

&#x20;                     },

&#x20;                     "height": {

&#x20;                       "px": {

&#x20;                         "value": 120,

&#x20;                         "isInfinity": false

&#x20;                       }

&#x20;                     },

&#x20;                     "radius": {

&#x20;                       "radius": {

&#x20;                         "topLeft": 40,

&#x20;                         "topRight": 40,

&#x20;                         "bottomLeft": 40,

&#x20;                         "bottomRight": 40

&#x20;                       }

&#x20;                     },

&#x20;                     "bg": {

&#x20;                       "color": {

&#x20;                         "color": "surface"

&#x20;                       }

&#x20;                     },

&#x20;                     "shadow": {

&#x20;                       "stringVal": {

&#x20;                         "value": "sm"

&#x20;                       }

&#x20;                     },

&#x20;                     "align\_child": {

&#x20;                       "align": {

&#x20;                         "named": "center"

&#x20;                       }

&#x20;                     }

&#x20;                   },

&#x20;                   "children": \[

&#x20;                     {

&#x20;                       "type": "stack",

&#x20;                       "properties": {

&#x20;                         "align": {

&#x20;                           "align": {

&#x20;                             "named": "center"

&#x20;                           }

&#x20;                         }

&#x20;                       },

&#x20;                       "children": \[

&#x20;                         {

&#x20;                           "type": "container",

&#x20;                           "properties": {

&#x20;                             "width": {

&#x20;                               "px": {

&#x20;                                 "value": 80,

&#x20;                                 "isInfinity": false

&#x20;                               }

&#x20;                             },

&#x20;                             "height": {

&#x20;                               "px": {

&#x20;                                 "value": 80,

&#x20;                                 "isInfinity": false

&#x20;                               }

&#x20;                             },

&#x20;                             "radius": {

&#x20;                               "radius": {

&#x20;                                 "topLeft": 28,

&#x20;                                 "topRight": 28,

&#x20;                                 "bottomLeft": 28,

&#x20;                                 "bottomRight": 28

&#x20;                               }

&#x20;                             },

&#x20;                             "border": {

&#x20;                               "border": {

&#x20;                                 "width": 2,

&#x20;                                 "color": "divider"

&#x20;                               }

&#x20;                             }

&#x20;                           },

&#x20;                           "editorId": "container23"

&#x20;                         },

&#x20;                         {

&#x20;                           "type": "icon",

&#x20;                           "properties": {

&#x20;                             "name": {

&#x20;                               "icon": {

&#x20;                                 "name": "auto\_graph\_rounded"

&#x20;                               }

&#x20;                             },

&#x20;                             "size": {

&#x20;                               "numberVal": {

&#x20;                                 "value": 42

&#x20;                               }

&#x20;                             },

&#x20;                             "color": {

&#x20;                               "color": {

&#x20;                                 "color": "primary"

&#x20;                               }

&#x20;                             }

&#x20;                           },

&#x20;                           "editorId": "icon10"

&#x20;                         }

&#x20;                       ],

&#x20;                       "editorId": "stack2"

&#x20;                     }

&#x20;                   ],

&#x20;                   "editorId": "container22"

&#x20;                 },

&#x20;                 {

&#x20;                   "type": "column",

&#x20;                   "properties": {

&#x20;                     "spacing": {

&#x20;                       "stringVal": {

&#x20;                         "value": "xs"

&#x20;                       }

&#x20;                     }

&#x20;                   },

&#x20;                   "children": \[

&#x20;                     {

&#x20;                       "type": "text",

&#x20;                       "properties": {

&#x20;                         "content": {

&#x20;                           "stringVal": {

&#x20;                             "value": "Life Tracker"

&#x20;                           }

&#x20;                         },

&#x20;                         "style": {

&#x20;                           "textStyle": {

&#x20;                             "styleName": "headline\_medium"

&#x20;                           }

&#x20;                         },

&#x20;                         "font\_weight": {

&#x20;                           "numberVal": {

&#x20;                             "value": 700

&#x20;                           }

&#x20;                         },

&#x20;                         "color": {

&#x20;                           "color": {

&#x20;                             "color": "primary\_text"

&#x20;                           }

&#x20;                         },

&#x20;                         "text\_align": {

&#x20;                           "align": {

&#x20;                             "named": "center"

&#x20;                           }

&#x20;                         }

&#x20;                       },

&#x20;                       "editorId": "text28"

&#x20;                     },

&#x20;                     {

&#x20;                       "type": "text",

&#x20;                       "properties": {

&#x20;                         "content": {

&#x20;                           "stringVal": {

&#x20;                             "value": "Offline. Minimal. Intentional."

&#x20;                           }

&#x20;                         },

&#x20;                         "style": {

&#x20;                           "textStyle": {

&#x20;                             "styleName": "body\_medium"

&#x20;                           }

&#x20;                         },

&#x20;                         "color": {

&#x20;                           "color": {

&#x20;                             "color": "secondary\_text"

&#x20;                           }

&#x20;                         },

&#x20;                         "text\_align": {

&#x20;                           "align": {

&#x20;                             "named": "center"

&#x20;                           }

&#x20;                         }

&#x20;                       },

&#x20;                       "editorId": "text29"

&#x20;                     }

&#x20;                   ],

&#x20;                   "editorId": "column16"

&#x20;                 }

&#x20;               ],

&#x20;               "editorId": "column15"

&#x20;             }

&#x20;           ],

&#x20;           "editorId": "center1"

&#x20;         },

&#x20;         {

&#x20;           "type": "container",

&#x20;           "properties": {

&#x20;             "align": {

&#x20;               "align": {

&#x20;                 "named": "bottom\_center"

&#x20;               }

&#x20;             },

&#x20;             "padding": {

&#x20;               "edgeInsets": {

&#x20;                 "top": 0,

&#x20;                 "right": 0,

&#x20;                 "bottom": 64,

&#x20;                 "left": 0

&#x20;               }

&#x20;             }

&#x20;           },

&#x20;           "children": \[

&#x20;             {

&#x20;               "type": "column",

&#x20;               "properties": {

&#x20;                 "spacing": {

&#x20;                   "stringVal": {

&#x20;                     "value": "md"

&#x20;                   }

&#x20;                 },

&#x20;                 "main\_size": {

&#x20;                   "stringVal": {

&#x20;                     "value": "min"

&#x20;                   }

&#x20;                 }

&#x20;               },

&#x20;               "children": \[

&#x20;                 {

&#x20;                   "type": "container",

&#x20;                   "properties": {

&#x20;                     "width": {

&#x20;                       "px": {

&#x20;                         "value": 180,

&#x20;                         "isInfinity": false

&#x20;                       }

&#x20;                     },

&#x20;                     "height": {

&#x20;                       "px": {

&#x20;                         "value": 4,

&#x20;                         "isInfinity": false

&#x20;                       }

&#x20;                     },

&#x20;                     "bg": {

&#x20;                       "color": {

&#x20;                         "color": "divider"

&#x20;                       }

&#x20;                     },

&#x20;                     "radius": {

&#x20;                       "radius": {

&#x20;                         "topLeft": 0,

&#x20;                         "topRight": 0,

&#x20;                         "bottomLeft": 0,

&#x20;                         "bottomRight": 0,

&#x20;                         "token": "full"

&#x20;                       }

&#x20;                     },

&#x20;                     "clip": {

&#x20;                       "boolVal": {

&#x20;                         "value": true

&#x20;                       }

&#x20;                     }

&#x20;                   },

&#x20;                   "children": \[

&#x20;                     {

&#x20;                       "type": "container",

&#x20;                       "properties": {

&#x20;                         "width": {

&#x20;                           "px": {

&#x20;                             "value": 60,

&#x20;                             "isInfinity": false

&#x20;                           }

&#x20;                         },

&#x20;                         "height": {

&#x20;                           "px": {

&#x20;                             "value": 4,

&#x20;                             "isInfinity": false

&#x20;                           }

&#x20;                         },

&#x20;                         "bg": {

&#x20;                           "color": {

&#x20;                             "color": "primary"

&#x20;                           }

&#x20;                         },

&#x20;                         "radius": {

&#x20;                           "radius": {

&#x20;                             "topLeft": 0,

&#x20;                             "topRight": 0,

&#x20;                             "bottomLeft": 0,

&#x20;                             "bottomRight": 0,

&#x20;                             "token": "full"

&#x20;                           }

&#x20;                         },

&#x20;                         "align": {

&#x20;                           "align": {

&#x20;                             "positional": {

&#x20;                               "x": -1,

&#x20;                               "y": 0

&#x20;                             }

&#x20;                           }

&#x20;                         }

&#x20;                       },

&#x20;                       "editorId": "container26"

&#x20;                     }

&#x20;                   ],

&#x20;                   "editorId": "container25"

&#x20;                 },

&#x20;                 {

&#x20;                   "type": "text",

&#x20;                   "properties": {

&#x20;                     "content": {

&#x20;                       "stringVal": {

&#x20;                         "value": "v1.0.0"

&#x20;                       }

&#x20;                     },

&#x20;                     "style": {

&#x20;                       "textStyle": {

&#x20;                         "styleName": "label\_small"

&#x20;                       }

&#x20;                     },

&#x20;                     "color": {

&#x20;                       "color": {

&#x20;                         "color": "on\_background"

&#x20;                       }

&#x20;                     }

&#x20;                   },

&#x20;                   "editorId": "text30"

&#x20;                 }

&#x20;               ],

&#x20;               "editorId": "column17"

&#x20;             }

&#x20;           ],

&#x20;           "editorId": "container24"

&#x20;         },

&#x20;         {

&#x20;           "type": "container",

&#x20;           "properties": {

&#x20;             "align": {

&#x20;               "align": {

&#x20;                 "named": "top\_right"

&#x20;               }

&#x20;             },

&#x20;             "margin": {

&#x20;               "edgeInsets": {

&#x20;                 "top": 0,

&#x20;                 "right": 0,

&#x20;                 "bottom": 0,

&#x20;                 "left": 0

&#x20;               }

&#x20;             }

&#x20;           },

&#x20;           "children": \[

&#x20;             {

&#x20;               "type": "container",

&#x20;               "properties": {

&#x20;                 "width": {

&#x20;                   "px": {

&#x20;                     "value": 200,

&#x20;                     "isInfinity": false

&#x20;                   }

&#x20;                 },

&#x20;                 "height": {

&#x20;                   "px": {

&#x20;                     "value": 200,

&#x20;                     "isInfinity": false

&#x20;                   }

&#x20;                 },

&#x20;                 "radius": {

&#x20;                   "radius": {

&#x20;                     "topLeft": 0,

&#x20;                     "topRight": 0,

&#x20;                     "bottomLeft": 0,

&#x20;                     "bottomRight": 0,

&#x20;                     "token": "full"

&#x20;                   }

&#x20;                 },

&#x20;                 "bg": {

&#x20;                   "color": {

&#x20;                     "color": "primary"

&#x20;                   }

&#x20;                 },

&#x20;                 "opacity": {

&#x20;                   "numberVal": {

&#x20;                     "value": 0.03

&#x20;                   }

&#x20;                 }

&#x20;               },

&#x20;               "editorId": "container28"

&#x20;             }

&#x20;           ],

&#x20;           "editorId": "container27"

&#x20;         },

&#x20;         {

&#x20;           "type": "container",

&#x20;           "properties": {

&#x20;             "align": {

&#x20;               "align": {

&#x20;                 "named": "bottom\_left"

&#x20;               }

&#x20;             },

&#x20;             "margin": {

&#x20;               "edgeInsets": {

&#x20;                 "top": 0,

&#x20;                 "right": 0,

&#x20;                 "bottom": 0,

&#x20;                 "left": 0

&#x20;               }

&#x20;             }

&#x20;           },

&#x20;           "children": \[

&#x20;             {

&#x20;               "type": "container",

&#x20;               "properties": {

&#x20;                 "width": {

&#x20;                   "px": {

&#x20;                     "value": 240,

&#x20;                     "isInfinity": false

&#x20;                   }

&#x20;                 },

&#x20;                 "height": {

&#x20;                   "px": {

&#x20;                     "value": 240,

&#x20;                     "isInfinity": false

&#x20;                   }

&#x20;                 },

&#x20;                 "radius": {

&#x20;                   "radius": {

&#x20;                     "topLeft": 0,

&#x20;                     "topRight": 0,

&#x20;                     "bottomLeft": 0,

&#x20;                     "bottomRight": 0,

&#x20;                     "token": "full"

&#x20;                   }

&#x20;                 },

&#x20;                 "bg": {

&#x20;                   "color": {

&#x20;                     "color": "accent"

&#x20;                   }

&#x20;                 },

&#x20;                 "opacity": {

&#x20;                   "numberVal": {

&#x20;                     "value": 0.03

&#x20;                   }

&#x20;                 }

&#x20;               },

&#x20;               "editorId": "container30"

&#x20;             }

&#x20;           ],

&#x20;           "editorId": "container29"

&#x20;         }

&#x20;       ],

&#x20;       "editorId": "stack1"

&#x20;     }

&#x20;   ],

&#x20;   "editorId": "scaffold1"

&#x20; }

}

```



\### 2. Dashboard



\- Frame ID: `frame8`

\- Original page prompt: "Main view with daily streak, category chips, and a list of active tracker cards for habits, goals, and counters."

\- Follow-up prompts: \_None\_



\#### DslDocument (JSON)



```json

{

&#x20; "root": {

&#x20;   "type": "scaffold",

&#x20;   "properties": {

&#x20;     "bg": {

&#x20;       "color": {

&#x20;         "color": "background"

&#x20;       }

&#x20;     },

&#x20;     "safe\_area": {

&#x20;       "boolVal": {

&#x20;         "value": true

&#x20;       }

&#x20;     }

&#x20;   },

&#x20;   "children": \[

&#x20;     {

&#x20;       "type": "stack",

&#x20;       "children": \[

&#x20;         {

&#x20;           "type": "column",

&#x20;           "properties": {

&#x20;             "scroll": {

&#x20;               "boolVal": {

&#x20;                 "value": true

&#x20;               }

&#x20;             },

&#x20;             "padding": {

&#x20;               "edgeInsets": {

&#x20;                 "top": 0,

&#x20;                 "right": 0,

&#x20;                 "bottom": 100,

&#x20;                 "left": 0

&#x20;               }

&#x20;             },

&#x20;             "cross\_align": {

&#x20;               "align": {

&#x20;                 "named": "stretch"

&#x20;               }

&#x20;             }

&#x20;           },

&#x20;           "children": \[

&#x20;             {

&#x20;               "type": "container",

&#x20;               "properties": {

&#x20;                 "padding": {

&#x20;                   "edgeInsets": {

&#x20;                     "top": 0,

&#x20;                     "right": 0,

&#x20;                     "bottom": 0,

&#x20;                     "left": 0,

&#x20;                     "token": "lg"

&#x20;                   }

&#x20;                 },

&#x20;                 "margin": {

&#x20;                   "edgeInsets": {

&#x20;                     "top": 0,

&#x20;                     "right": 0,

&#x20;                     "bottom": 0,

&#x20;                     "left": 0,

&#x20;                     "bottomToken": "md"

&#x20;                   }

&#x20;                 }

&#x20;               },

&#x20;               "children": \[

&#x20;                 {

&#x20;                   "type": "row",

&#x20;                   "properties": {

&#x20;                     "align": {

&#x20;                       "align": {

&#x20;                         "named": "space\_between"

&#x20;                       }

&#x20;                     },

&#x20;                     "cross\_align": {

&#x20;                       "align": {

&#x20;                         "named": "center"

&#x20;                       }

&#x20;                     }

&#x20;                   },

&#x20;                   "children": \[

&#x20;                     {

&#x20;                       "type": "column",

&#x20;                       "properties": {

&#x20;                         "cross\_align": {

&#x20;                           "align": {

&#x20;                             "named": "start"

&#x20;                           }

&#x20;                         },

&#x20;                         "spacing": {

&#x20;                           "stringVal": {

&#x20;                             "value": "xs"

&#x20;                           }

&#x20;                         }

&#x20;                       },

&#x20;                       "children": \[

&#x20;                         {

&#x20;                           "type": "text",

&#x20;                           "properties": {

&#x20;                             "content": {

&#x20;                               "stringVal": {

&#x20;                                 "value": "October 24"

&#x20;                               }

&#x20;                             },

&#x20;                             "style": {

&#x20;                               "textStyle": {

&#x20;                                 "styleName": "body\_medium"

&#x20;                               }

&#x20;                             },

&#x20;                             "color": {

&#x20;                               "color": {

&#x20;                                 "color": "secondary\_text"

&#x20;                               }

&#x20;                             }

&#x20;                           },

&#x20;                           "editorId": "text39"

&#x20;                         },

&#x20;                         {

&#x20;                           "type": "text",

&#x20;                           "properties": {

&#x20;                             "content": {

&#x20;                               "stringVal": {

&#x20;                                 "value": "Hello, Alex"

&#x20;                               }

&#x20;                             },

&#x20;                             "style": {

&#x20;                               "textStyle": {

&#x20;                                 "styleName": "headline\_medium"

&#x20;                               }

&#x20;                             },

&#x20;                             "font\_weight": {

&#x20;                               "numberVal": {

&#x20;                                 "value": 800

&#x20;                               }

&#x20;                             },

&#x20;                             "color": {

&#x20;                               "color": {

&#x20;                                 "color": "primary\_text"

&#x20;                               }

&#x20;                             }

&#x20;                           },

&#x20;                           "editorId": "text40"

&#x20;                         }

&#x20;                       ],

&#x20;                       "editorId": "column24"

&#x20;                     },

&#x20;                     {

&#x20;                       "type": "container",

&#x20;                       "properties": {

&#x20;                         "bg": {

&#x20;                           "color": {

&#x20;                             "color": "#FFF4E5"

&#x20;                           }

&#x20;                         },

&#x20;                         "radius": {

&#x20;                           "radius": {

&#x20;                             "topLeft": 0,

&#x20;                             "topRight": 0,

&#x20;                             "bottomLeft": 0,

&#x20;                             "bottomRight": 0,

&#x20;                             "token": "full"

&#x20;                           }

&#x20;                         },

&#x20;                         "padding": {

&#x20;                           "edgeInsets": {

&#x20;                             "top": 0,

&#x20;                             "right": 0,

&#x20;                             "bottom": 0,

&#x20;                             "left": 0,

&#x20;                             "topToken": "sm",

&#x20;                             "rightToken": "md",

&#x20;                             "bottomToken": "sm",

&#x20;                             "leftToken": "md"

&#x20;                           }

&#x20;                         },

&#x20;                         "border": {

&#x20;                           "border": {

&#x20;                             "width": 1,

&#x20;                             "color": "#FFE0B2"

&#x20;                           }

&#x20;                         }

&#x20;                       },

&#x20;                       "children": \[

&#x20;                         {

&#x20;                           "type": "row",

&#x20;                           "properties": {

&#x20;                             "spacing": {

&#x20;                               "stringVal": {

&#x20;                                 "value": "xs"

&#x20;                               }

&#x20;                             }

&#x20;                           },

&#x20;                           "children": \[

&#x20;                             {

&#x20;                               "type": "text",

&#x20;                               "properties": {

&#x20;                                 "content": {

&#x20;                                   "stringVal": {

&#x20;                                     "value": "🔥"

&#x20;                                   }

&#x20;                                 },

&#x20;                                 "font\_size": {

&#x20;                                   "numberVal": {

&#x20;                                     "value": 16

&#x20;                                   }

&#x20;                                 }

&#x20;                               },

&#x20;                               "editorId": "text41"

&#x20;                             },

&#x20;                             {

&#x20;                               "type": "text",

&#x20;                               "properties": {

&#x20;                                 "content": {

&#x20;                                   "stringVal": {

&#x20;                                     "value": "12 Days"

&#x20;                                   }

&#x20;                                 },

&#x20;                                 "style": {

&#x20;                                   "textStyle": {

&#x20;                                     "styleName": "label\_large"

&#x20;                                   }

&#x20;                                 },

&#x20;                                 "color": {

&#x20;                                   "color": {

&#x20;                                     "color": "#E65100"

&#x20;                                   }

&#x20;                                 },

&#x20;                                 "font\_weight": {

&#x20;                                   "numberVal": {

&#x20;                                     "value": 700

&#x20;                                   }

&#x20;                                 }

&#x20;                               },

&#x20;                               "editorId": "text42"

&#x20;                             }

&#x20;                           ],

&#x20;                           "editorId": "row20"

&#x20;                         }

&#x20;                       ],

&#x20;                       "editorId": "container33"

&#x20;                     }

&#x20;                   ],

&#x20;                   "editorId": "row19"

&#x20;                 }

&#x20;               ],

&#x20;               "editorId": "container32"

&#x20;             },

&#x20;             {

&#x20;               "type": "container",

&#x20;               "properties": {

&#x20;                 "margin": {

&#x20;                   "edgeInsets": {

&#x20;                     "top": 0,

&#x20;                     "right": 0,

&#x20;                     "bottom": 0,

&#x20;                     "left": 0,

&#x20;                     "rightToken": "lg",

&#x20;                     "bottomToken": "lg",

&#x20;                     "leftToken": "lg"

&#x20;                   }

&#x20;                 },

&#x20;                 "padding": {

&#x20;                   "edgeInsets": {

&#x20;                     "top": 0,

&#x20;                     "right": 0,

&#x20;                     "bottom": 0,

&#x20;                     "left": 0,

&#x20;                     "token": "lg"

&#x20;                   }

&#x20;                 },

&#x20;                 "bg": {

&#x20;                   "color": {

&#x20;                     "color": "surface"

&#x20;                   }

&#x20;                 },

&#x20;                 "radius": {

&#x20;                   "radius": {

&#x20;                     "topLeft": 0,

&#x20;                     "topRight": 0,

&#x20;                     "bottomLeft": 0,

&#x20;                     "bottomRight": 0,

&#x20;                     "token": "xl"

&#x20;                   }

&#x20;                 },

&#x20;                 "border": {

&#x20;                   "border": {

&#x20;                     "width": 1,

&#x20;                     "color": "divider"

&#x20;                   }

&#x20;                 }

&#x20;               },

&#x20;               "children": \[

&#x20;                 {

&#x20;                   "type": "row",

&#x20;                   "properties": {

&#x20;                     "spacing": {

&#x20;                       "stringVal": {

&#x20;                         "value": "lg"

&#x20;                       }

&#x20;                     }

&#x20;                   },

&#x20;                   "children": \[

&#x20;                     {

&#x20;                       "type": "stack",

&#x20;                       "properties": {

&#x20;                         "width": {

&#x20;                           "px": {

&#x20;                             "value": 80,

&#x20;                             "isInfinity": false

&#x20;                           }

&#x20;                         },

&#x20;                         "height": {

&#x20;                           "px": {

&#x20;                             "value": 80,

&#x20;                             "isInfinity": false

&#x20;                           }

&#x20;                         },

&#x20;                         "align\_child": {

&#x20;                           "align": {

&#x20;                             "named": "center"

&#x20;                           }

&#x20;                         }

&#x20;                       },

&#x20;                       "children": \[

&#x20;                         {

&#x20;                           "type": "progress",

&#x20;                           "properties": {

&#x20;                             "value": {

&#x20;                               "numberVal": {

&#x20;                                 "value": 0.75

&#x20;                               }

&#x20;                             },

&#x20;                             "variant": {

&#x20;                               "stringVal": {

&#x20;                                 "value": "circular"

&#x20;                               }

&#x20;                             },

&#x20;                             "thickness": {

&#x20;                               "numberVal": {

&#x20;                                 "value": 8

&#x20;                               }

&#x20;                             },

&#x20;                             "color": {

&#x20;                               "color": {

&#x20;                                 "color": "primary"

&#x20;                               }

&#x20;                             },

&#x20;                             "bg\_color": {

&#x20;                               "color": {

&#x20;                                 "color": "divider"

&#x20;                               }

&#x20;                             },

&#x20;                             "size": {

&#x20;                               "numberVal": {

&#x20;                                 "value": 80

&#x20;                               }

&#x20;                             }

&#x20;                           },

&#x20;                           "editorId": "progress2"

&#x20;                         },

&#x20;                         {

&#x20;                           "type": "text",

&#x20;                           "properties": {

&#x20;                             "content": {

&#x20;                               "stringVal": {

&#x20;                                 "value": "75%"

&#x20;                               }

&#x20;                             },

&#x20;                             "style": {

&#x20;                               "textStyle": {

&#x20;                                 "styleName": "title\_medium"

&#x20;                               }

&#x20;                             },

&#x20;                             "font\_weight": {

&#x20;                               "stringVal": {

&#x20;                                 "value": "bold"

&#x20;                               }

&#x20;                             }

&#x20;                           },

&#x20;                           "editorId": "text43"

&#x20;                         }

&#x20;                       ],

&#x20;                       "editorId": "stack4"

&#x20;                     },

&#x20;                     {

&#x20;                       "type": "expanded",

&#x20;                       "children": \[

&#x20;                         {

&#x20;                           "type": "column",

&#x20;                           "properties": {

&#x20;                             "cross\_align": {

&#x20;                               "align": {

&#x20;                                 "named": "start"

&#x20;                               }

&#x20;                             },

&#x20;                             "spacing": {

&#x20;                               "stringVal": {

&#x20;                                 "value": "xs"

&#x20;                               }

&#x20;                             }

&#x20;                           },

&#x20;                           "children": \[

&#x20;                             {

&#x20;                               "type": "text",

&#x20;                               "properties": {

&#x20;                                 "content": {

&#x20;                                   "stringVal": {

&#x20;                                     "value": "Daily Progress"

&#x20;                                   }

&#x20;                                 },

&#x20;                                 "style": {

&#x20;                                   "textStyle": {

&#x20;                                     "styleName": "title\_small"

&#x20;                                   }

&#x20;                                 },

&#x20;                                 "font\_weight": {

&#x20;                                   "numberVal": {

&#x20;                                     "value": 600

&#x20;                                   }

&#x20;                                 }

&#x20;                               },

&#x20;                               "editorId": "text44"

&#x20;                             },

&#x20;                             {

&#x20;                               "type": "text",

&#x20;                               "properties": {

&#x20;                                 "content": {

&#x20;                                   "stringVal": {

&#x20;                                     "value": "6 of 8 trackers completed today"

&#x20;                                   }

&#x20;                                 },

&#x20;                                 "style": {

&#x20;                                   "textStyle": {

&#x20;                                     "styleName": "body\_small"

&#x20;                                   }

&#x20;                                 },

&#x20;                                 "color": {

&#x20;                                   "color": {

&#x20;                                     "color": "secondary\_text"

&#x20;                                   }

&#x20;                                 },

&#x20;                                 "max\_lines": {

&#x20;                                   "numberVal": {

&#x20;                                     "value": 2

&#x20;                                   }

&#x20;                                 }

&#x20;                               },

&#x20;                               "editorId": "text45"

&#x20;                             }

&#x20;                           ],

&#x20;                           "editorId": "column25"

&#x20;                         }

&#x20;                       ],

&#x20;                       "editorId": "expanded10"

&#x20;                     }

&#x20;                   ],

&#x20;                   "editorId": "row21"

&#x20;                 }

&#x20;               ],

&#x20;               "editorId": "container34"

&#x20;             },

&#x20;             {

&#x20;               "type": "row",

&#x20;               "properties": {

&#x20;                 "scroll": {

&#x20;                   "boolVal": {

&#x20;                     "value": true

&#x20;                   }

&#x20;                 },

&#x20;                 "padding": {

&#x20;                   "edgeInsets": {

&#x20;                     "top": 0,

&#x20;                     "right": 0,

&#x20;                     "bottom": 0,

&#x20;                     "left": 0,

&#x20;                     "rightToken": "lg",

&#x20;                     "bottomToken": "md",

&#x20;                     "leftToken": "lg"

&#x20;                   }

&#x20;                 }

&#x20;               },

&#x20;               "children": \[

&#x20;                 {

&#x20;                   "type": "@category\_chip",

&#x20;                   "properties": {

&#x20;                     "label": {

&#x20;                       "stringVal": {

&#x20;                         "value": "All"

&#x20;                       }

&#x20;                     },

&#x20;                     "icon": {

&#x20;                       "stringVal": {

&#x20;                         "value": "grid\_view\_rounded"

&#x20;                       }

&#x20;                     },

&#x20;                     "selected": {

&#x20;                       "boolVal": {

&#x20;                         "value": true

&#x20;                       }

&#x20;                     }

&#x20;                   },

&#x20;                   "editorId": "cat1"

&#x20;                 },

&#x20;                 {

&#x20;                   "type": "@category\_chip",

&#x20;                   "properties": {

&#x20;                     "label": {

&#x20;                       "stringVal": {

&#x20;                         "value": "Health"

&#x20;                       }

&#x20;                     },

&#x20;                     "icon": {

&#x20;                       "stringVal": {

&#x20;                         "value": "favorite\_rounded"

&#x20;                       }

&#x20;                     },

&#x20;                     "selected": {

&#x20;                       "boolVal": {

&#x20;                         "value": false

&#x20;                       }

&#x20;                     }

&#x20;                   },

&#x20;                   "editorId": "cat2"

&#x20;                 },

&#x20;                 {

&#x20;                   "type": "@category\_chip",

&#x20;                   "properties": {

&#x20;                     "label": {

&#x20;                       "stringVal": {

&#x20;                         "value": "Focus"

&#x20;                       }

&#x20;                     },

&#x20;                     "icon": {

&#x20;                       "stringVal": {

&#x20;                         "value": "self\_improvement\_rounded"

&#x20;                       }

&#x20;                     },

&#x20;                     "selected": {

&#x20;                       "boolVal": {

&#x20;                         "value": false

&#x20;                       }

&#x20;                     }

&#x20;                   },

&#x20;                   "editorId": "cat3"

&#x20;                 },

&#x20;                 {

&#x20;                   "type": "@category\_chip",

&#x20;                   "properties": {

&#x20;                     "label": {

&#x20;                       "stringVal": {

&#x20;                         "value": "Work"

&#x20;                       }

&#x20;                     },

&#x20;                     "icon": {

&#x20;                       "stringVal": {

&#x20;                         "value": "work\_outline\_rounded"

&#x20;                       }

&#x20;                     },

&#x20;                     "selected": {

&#x20;                       "boolVal": {

&#x20;                         "value": false

&#x20;                       }

&#x20;                     }

&#x20;                   },

&#x20;                   "editorId": "cat4"

&#x20;                 }

&#x20;               ],

&#x20;               "editorId": "row22"

&#x20;             },

&#x20;             {

&#x20;               "type": "column",

&#x20;               "properties": {

&#x20;                 "padding": {

&#x20;                   "edgeInsets": {

&#x20;                     "top": 0,

&#x20;                     "right": 0,

&#x20;                     "bottom": 0,

&#x20;                     "left": 0,

&#x20;                     "rightToken": "lg",

&#x20;                     "leftToken": "lg"

&#x20;                   }

&#x20;                 },

&#x20;                 "cross\_align": {

&#x20;                   "align": {

&#x20;                     "named": "stretch"

&#x20;                   }

&#x20;                 }

&#x20;               },

&#x20;               "children": \[

&#x20;                 {

&#x20;                   "type": "text",

&#x20;                   "properties": {

&#x20;                     "content": {

&#x20;                       "stringVal": {

&#x20;                         "value": "Today's Trackers"

&#x20;                       }

&#x20;                     },

&#x20;                     "style": {

&#x20;                       "textStyle": {

&#x20;                         "styleName": "title\_small"

&#x20;                       }

&#x20;                     },

&#x20;                     "color": {

&#x20;                       "color": {

&#x20;                         "color": "secondary\_text"

&#x20;                       }

&#x20;                     },

&#x20;                     "margin": {

&#x20;                       "edgeInsets": {

&#x20;                         "top": 0,

&#x20;                         "right": 0,

&#x20;                         "bottom": 0,

&#x20;                         "left": 0,

&#x20;                         "bottomToken": "sm"

&#x20;                       }

&#x20;                     }

&#x20;                   },

&#x20;                   "editorId": "text46"

&#x20;                 },

&#x20;                 {

&#x20;                   "type": "@tracker\_card",

&#x20;                   "properties": {

&#x20;                     "type": {

&#x20;                       "stringVal": {

&#x20;                         "value": "habit"

&#x20;                       }

&#x20;                     },

&#x20;                     "name": {

&#x20;                       "stringVal": {

&#x20;                         "value": "Morning Meditation"

&#x20;                       }

&#x20;                     },

&#x20;                     "subtitle": {

&#x20;                       "stringVal": {

&#x20;                         "value": "10 mins • Daily"

&#x20;                       }

&#x20;                     },

&#x20;                     "icon": {

&#x20;                       "stringVal": {

&#x20;                         "value": "self\_improvement\_rounded"

&#x20;                       }

&#x20;                     },

&#x20;                     "color\_bg": {

&#x20;                       "color": {

&#x20;                         "color": "#E0F2F1"

&#x20;                       }

&#x20;                     },

&#x20;                     "color\_text": {

&#x20;                       "color": {

&#x20;                         "color": "#00897B"

&#x20;                       }

&#x20;                     },

&#x20;                     "status": {

&#x20;                       "stringVal": {

&#x20;                         "value": "Done"

&#x20;                       }

&#x20;                     },

&#x20;                     "meta": {

&#x20;                       "numberVal": {

&#x20;                         "value": 60

&#x20;                       }

&#x20;                     }

&#x20;                   },

&#x20;                   "editorId": "card1"

&#x20;                 },

&#x20;                 {

&#x20;                   "type": "@tracker\_card",

&#x20;                   "properties": {

&#x20;                     "type": {

&#x20;                       "stringVal": {

&#x20;                         "value": "counter"

&#x20;                       }

&#x20;                     },

&#x20;                     "name": {

&#x20;                       "stringVal": {

&#x20;                         "value": "Water Intake"

&#x20;                       }

&#x20;                     },

&#x20;                     "subtitle": {

&#x20;                       "stringVal": {

&#x20;                         "value": "Goal: 8 glasses"

&#x20;                       }

&#x20;                     },

&#x20;                     "icon": {

&#x20;                       "stringVal": {

&#x20;                         "value": "water\_drop\_rounded"

&#x20;                       }

&#x20;                     },

&#x20;                     "color\_bg": {

&#x20;                       "color": {

&#x20;                         "color": "#E3F2FD"

&#x20;                       }

&#x20;                     },

&#x20;                     "color\_text": {

&#x20;                       "color": {

&#x20;                         "color": "#1E88E5"

&#x20;                       }

&#x20;                     },

&#x20;                     "status": {

&#x20;                       "stringVal": {

&#x20;                         "value": "5/8"

&#x20;                       }

&#x20;                     },

&#x20;                     "meta": {

&#x20;                       "numberVal": {

&#x20;                         "value": 62

&#x20;                       }

&#x20;                     }

&#x20;                   },

&#x20;                   "editorId": "card2"

&#x20;                 },

&#x20;                 {

&#x20;                   "type": "@tracker\_card",

&#x20;                   "properties": {

&#x20;                     "type": {

&#x20;                       "stringVal": {

&#x20;                         "value": "habit"

&#x20;                       }

&#x20;                     },

&#x20;                     "name": {

&#x20;                       "stringVal": {

&#x20;                         "value": "Read 20 Pages"

&#x20;                       }

&#x20;                     },

&#x20;                     "subtitle": {

&#x20;                       "stringVal": {

&#x20;                         "value": "Daily • Evening"

&#x20;                       }

&#x20;                     },

&#x20;                     "icon": {

&#x20;                       "stringVal": {

&#x20;                         "value": "menu\_book\_rounded"

&#x20;                       }

&#x20;                     },

&#x20;                     "color\_bg": {

&#x20;                       "color": {

&#x20;                         "color": "#F3E5F5"

&#x20;                       }

&#x20;                     },

&#x20;                     "color\_text": {

&#x20;                       "color": {

&#x20;                         "color": "#8E24AA"

&#x20;                       }

&#x20;                     },

&#x20;                     "status": {

&#x20;                       "stringVal": {

&#x20;                         "value": "Pending"

&#x20;                       }

&#x20;                     },

&#x20;                     "meta": {

&#x20;                       "numberVal": {

&#x20;                         "value": 0

&#x20;                       }

&#x20;                     }

&#x20;                   },

&#x20;                   "editorId": "card3"

&#x20;                 },

&#x20;                 {

&#x20;                   "type": "@tracker\_card",

&#x20;                   "properties": {

&#x20;                     "type": {

&#x20;                       "stringVal": {

&#x20;                         "value": "timer"

&#x20;                       }

&#x20;                     },

&#x20;                     "name": {

&#x20;                       "stringVal": {

&#x20;                         "value": "Deep Work"

&#x20;                       }

&#x20;                     },

&#x20;                     "subtitle": {

&#x20;                       "stringVal": {

&#x20;                         "value": "Session: 45 mins"

&#x20;                       }

&#x20;                     },

&#x20;                     "icon": {

&#x20;                       "stringVal": {

&#x20;                         "value": "timer\_rounded"

&#x20;                       }

&#x20;                     },

&#x20;                     "color\_bg": {

&#x20;                       "color": {

&#x20;                         "color": "#FFF3E0"

&#x20;                       }

&#x20;                     },

&#x20;                     "color\_text": {

&#x20;                       "color": {

&#x20;                         "color": "#FB8C00"

&#x20;                       }

&#x20;                     },

&#x20;                     "status": {

&#x20;                       "stringVal": {

&#x20;                         "value": "00:00"

&#x20;                       }

&#x20;                     }

&#x20;                   },

&#x20;                   "editorId": "card4"

&#x20;                 },

&#x20;                 {

&#x20;                   "type": "@tracker\_card",

&#x20;                   "properties": {

&#x20;                     "type": {

&#x20;                       "stringVal": {

&#x20;                         "value": "counter"

&#x20;                       }

&#x20;                     },

&#x20;                     "name": {

&#x20;                       "stringVal": {

&#x20;                         "value": "Steps"

&#x20;                       }

&#x20;                     },

&#x20;                     "subtitle": {

&#x20;                       "stringVal": {

&#x20;                         "value": "Goal: 10,000"

&#x20;                       }

&#x20;                     },

&#x20;                     "icon": {

&#x20;                       "stringVal": {

&#x20;                         "value": "directions\_walk\_rounded"

&#x20;                       }

&#x20;                     },

&#x20;                     "color\_bg": {

&#x20;                       "color": {

&#x20;                         "color": "#E8F5E9"

&#x20;                       }

&#x20;                     },

&#x20;                     "color\_text": {

&#x20;                       "color": {

&#x20;                         "color": "#43A047"

&#x20;                       }

&#x20;                     },

&#x20;                     "status": {

&#x20;                       "stringVal": {

&#x20;                         "value": "8.2k"

&#x20;                       }

&#x20;                     },

&#x20;                     "meta": {

&#x20;                       "numberVal": {

&#x20;                         "value": 82

&#x20;                       }

&#x20;                     }

&#x20;                   },

&#x20;                   "editorId": "card5"

&#x20;                 }

&#x20;               ],

&#x20;               "editorId": "column26"

&#x20;             }

&#x20;           ],

&#x20;           "editorId": "column23"

&#x20;         },

&#x20;         {

&#x20;           "type": "container",

&#x20;           "properties": {

&#x20;             "align": {

&#x20;               "align": {

&#x20;                 "named": "bottom\_right"

&#x20;               }

&#x20;             },

&#x20;             "margin": {

&#x20;               "edgeInsets": {

&#x20;                 "top": 0,

&#x20;                 "right": 0,

&#x20;                 "bottom": 0,

&#x20;                 "left": 0,

&#x20;                 "token": "lg"

&#x20;               }

&#x20;             },

&#x20;             "width": {

&#x20;               "px": {

&#x20;                 "value": 64,

&#x20;                 "isInfinity": false

&#x20;               }

&#x20;             },

&#x20;             "height": {

&#x20;               "px": {

&#x20;                 "value": 64,

&#x20;                 "isInfinity": false

&#x20;               }

&#x20;             },

&#x20;             "radius": {

&#x20;               "radius": {

&#x20;                 "topLeft": 20,

&#x20;                 "topRight": 20,

&#x20;                 "bottomLeft": 20,

&#x20;                 "bottomRight": 20

&#x20;               }

&#x20;             },

&#x20;             "bg": {

&#x20;               "color": {

&#x20;                 "color": "primary"

&#x20;               }

&#x20;             },

&#x20;             "shadow": {

&#x20;               "stringVal": {

&#x20;                 "value": "lg"

&#x20;               }

&#x20;             },

&#x20;             "align\_child": {

&#x20;               "align": {

&#x20;                 "named": "center"

&#x20;               }

&#x20;             }

&#x20;           },

&#x20;           "children": \[

&#x20;             {

&#x20;               "type": "icon",

&#x20;               "properties": {

&#x20;                 "name": {

&#x20;                   "icon": {

&#x20;                     "name": "add\_rounded"

&#x20;                   }

&#x20;                 },

&#x20;                 "color": {

&#x20;                   "color": {

&#x20;                     "color": "on\_primary"

&#x20;                   }

&#x20;                 },

&#x20;                 "size": {

&#x20;                   "numberVal": {

&#x20;                     "value": 32

&#x20;                   }

&#x20;                 }

&#x20;               },

&#x20;               "editorId": "icon16"

&#x20;             }

&#x20;           ],

&#x20;           "editorId": "container35"

&#x20;         },

&#x20;         {

&#x20;           "type": "container",

&#x20;           "properties": {

&#x20;             "align": {

&#x20;               "align": {

&#x20;                 "named": "bottom\_center"

&#x20;               }

&#x20;             },

&#x20;             "height": {

&#x20;               "px": {

&#x20;                 "value": 80,

&#x20;                 "isInfinity": false

&#x20;               }

&#x20;             },

&#x20;             "bg": {

&#x20;               "color": {

&#x20;                 "color": "surface",

&#x20;                 "opacityPercent": 90

&#x20;               }

&#x20;             },

&#x20;             "backdrop\_blur": {

&#x20;               "numberVal": {

&#x20;                 "value": 10

&#x20;               }

&#x20;             },

&#x20;             "border": {

&#x20;               "borderSided": {

&#x20;                 "side": "top",

&#x20;                 "width": 1,

&#x20;                 "color": "divider"

&#x20;               }

&#x20;             },

&#x20;             "padding": {

&#x20;               "edgeInsets": {

&#x20;                 "top": 0,

&#x20;                 "right": 0,

&#x20;                 "bottom": 0,

&#x20;                 "left": 0,

&#x20;                 "rightToken": "lg",

&#x20;                 "leftToken": "lg"

&#x20;               }

&#x20;             }

&#x20;           },

&#x20;           "children": \[

&#x20;             {

&#x20;               "type": "row",

&#x20;               "properties": {

&#x20;                 "align": {

&#x20;                   "align": {

&#x20;                     "named": "space\_around"

&#x20;                   }

&#x20;                 },

&#x20;                 "cross\_align": {

&#x20;                   "align": {

&#x20;                     "named": "center"

&#x20;                   }

&#x20;                 }

&#x20;               },

&#x20;               "children": \[

&#x20;                 {

&#x20;                   "type": "column",

&#x20;                   "properties": {

&#x20;                     "spacing": {

&#x20;                       "stringVal": {

&#x20;                         "value": "xs"

&#x20;                       }

&#x20;                     }

&#x20;                   },

&#x20;                   "children": \[

&#x20;                     {

&#x20;                       "type": "icon",

&#x20;                       "properties": {

&#x20;                         "name": {

&#x20;                           "icon": {

&#x20;                             "name": "dashboard\_rounded"

&#x20;                           }

&#x20;                         },

&#x20;                         "color": {

&#x20;                           "color": {

&#x20;                             "color": "primary"

&#x20;                           }

&#x20;                         },

&#x20;                         "size": {

&#x20;                           "numberVal": {

&#x20;                             "value": 26

&#x20;                           }

&#x20;                         }

&#x20;                       },

&#x20;                       "editorId": "icon17"

&#x20;                     },

&#x20;                     {

&#x20;                       "type": "text",

&#x20;                       "properties": {

&#x20;                         "content": {

&#x20;                           "stringVal": {

&#x20;                             "value": "Home"

&#x20;                           }

&#x20;                         },

&#x20;                         "style": {

&#x20;                           "textStyle": {

&#x20;                             "styleName": "label\_small"

&#x20;                           }

&#x20;                         },

&#x20;                         "color": {

&#x20;                           "color": {

&#x20;                             "color": "primary"

&#x20;                           }

&#x20;                         }

&#x20;                       },

&#x20;                       "editorId": "text47"

&#x20;                     }

&#x20;                   ],

&#x20;                   "editorId": "column27"

&#x20;                 },

&#x20;                 {

&#x20;                   "type": "column",

&#x20;                   "properties": {

&#x20;                     "spacing": {

&#x20;                       "stringVal": {

&#x20;                         "value": "xs"

&#x20;                       }

&#x20;                     }

&#x20;                   },

&#x20;                   "children": \[

&#x20;                     {

&#x20;                       "type": "icon",

&#x20;                       "properties": {

&#x20;                         "name": {

&#x20;                           "icon": {

&#x20;                             "name": "category\_rounded"

&#x20;                           }

&#x20;                         },

&#x20;                         "color": {

&#x20;                           "color": {

&#x20;                             "color": "secondary\_text"

&#x20;                           }

&#x20;                         },

&#x20;                         "size": {

&#x20;                           "numberVal": {

&#x20;                             "value": 26

&#x20;                           }

&#x20;                         }

&#x20;                       },

&#x20;                       "editorId": "icon18"

&#x20;                     },

&#x20;                     {

&#x20;                       "type": "text",

&#x20;                       "properties": {

&#x20;                         "content": {

&#x20;                           "stringVal": {

&#x20;                             "value": "Categories"

&#x20;                           }

&#x20;                         },

&#x20;                         "style": {

&#x20;                           "textStyle": {

&#x20;                             "styleName": "label\_small"

&#x20;                           }

&#x20;                         },

&#x20;                         "color": {

&#x20;                           "color": {

&#x20;                             "color": "secondary\_text"

&#x20;                           }

&#x20;                         }

&#x20;                       },

&#x20;                       "editorId": "text48"

&#x20;                     }

&#x20;                   ],

&#x20;                   "editorId": "column28"

&#x20;                 },

&#x20;                 {

&#x20;                   "type": "column",

&#x20;                   "properties": {

&#x20;                     "spacing": {

&#x20;                       "stringVal": {

&#x20;                         "value": "xs"

&#x20;                       }

&#x20;                     }

&#x20;                   },

&#x20;                   "children": \[

&#x20;                     {

&#x20;                       "type": "icon",

&#x20;                       "properties": {

&#x20;                         "name": {

&#x20;                           "icon": {

&#x20;                             "name": "insights\_rounded"

&#x20;                           }

&#x20;                         },

&#x20;                         "color": {

&#x20;                           "color": {

&#x20;                             "color": "secondary\_text"

&#x20;                           }

&#x20;                         },

&#x20;                         "size": {

&#x20;                           "numberVal": {

&#x20;                             "value": 26

&#x20;                           }

&#x20;                         }

&#x20;                       },

&#x20;                       "editorId": "icon19"

&#x20;                     },

&#x20;                     {

&#x20;                       "type": "text",

&#x20;                       "properties": {

&#x20;                         "content": {

&#x20;                           "stringVal": {

&#x20;                             "value": "Insights"

&#x20;                           }

&#x20;                         },

&#x20;                         "style": {

&#x20;                           "textStyle": {

&#x20;                             "styleName": "label\_small"

&#x20;                           }

&#x20;                         },

&#x20;                         "color": {

&#x20;                           "color": {

&#x20;                             "color": "secondary\_text"

&#x20;                           }

&#x20;                         }

&#x20;                       },

&#x20;                       "editorId": "text49"

&#x20;                     }

&#x20;                   ],

&#x20;                   "editorId": "column29"

&#x20;                 },

&#x20;                 {

&#x20;                   "type": "column",

&#x20;                   "properties": {

&#x20;                     "spacing": {

&#x20;                       "stringVal": {

&#x20;                         "value": "xs"

&#x20;                       }

&#x20;                     }

&#x20;                   },

&#x20;                   "children": \[

&#x20;                     {

&#x20;                       "type": "icon",

&#x20;                       "properties": {

&#x20;                         "name": {

&#x20;                           "icon": {

&#x20;                             "name": "settings\_rounded"

&#x20;                           }

&#x20;                         },

&#x20;                         "color": {

&#x20;                           "color": {

&#x20;                             "color": "secondary\_text"

&#x20;                           }

&#x20;                         },

&#x20;                         "size": {

&#x20;                           "numberVal": {

&#x20;                             "value": 26

&#x20;                           }

&#x20;                         }

&#x20;                       },

&#x20;                       "editorId": "icon20"

&#x20;                     },

&#x20;                     {

&#x20;                       "type": "text",

&#x20;                       "properties": {

&#x20;                         "content": {

&#x20;                           "stringVal": {

&#x20;                             "value": "Settings"

&#x20;                           }

&#x20;                         },

&#x20;                         "style": {

&#x20;                           "textStyle": {

&#x20;                             "styleName": "label\_small"

&#x20;                           }

&#x20;                         },

&#x20;                         "color": {

&#x20;                           "color": {

&#x20;                             "color": "secondary\_text"

&#x20;                           }

&#x20;                         }

&#x20;                       },

&#x20;                       "editorId": "text50"

&#x20;                     }

&#x20;                   ],

&#x20;                   "editorId": "column30"

&#x20;                 }

&#x20;               ],

&#x20;               "editorId": "row23"

&#x20;             }

&#x20;           ],

&#x20;           "editorId": "container36"

&#x20;         }

&#x20;       ],

&#x20;       "editorId": "stack3"

&#x20;     }

&#x20;   ],

&#x20;   "editorId": "scaffold2"

&#x20; }

}

```



\### 3. Add/Edit Tracker



\- Frame ID: `frame4`

\- Original page prompt: "Form to configure tracker type, frequency, target values, and local reminder notifications."

\- Follow-up prompts: \_None\_



\#### DslDocument (JSON)



```json

{

&#x20; "root": {

&#x20;   "type": "scaffold",

&#x20;   "properties": {

&#x20;     "bg": {

&#x20;       "color": {

&#x20;         "color": "background"

&#x20;       }

&#x20;     },

&#x20;     "safe\_area": {

&#x20;       "boolVal": {

&#x20;         "value": true

&#x20;       }

&#x20;     }

&#x20;   },

&#x20;   "children": \[

&#x20;     {

&#x20;       "type": "column",

&#x20;       "properties": {

&#x20;         "scroll": {

&#x20;           "boolVal": {

&#x20;             "value": true

&#x20;           }

&#x20;         },

&#x20;         "cross\_align": {

&#x20;           "align": {

&#x20;             "named": "stretch"

&#x20;           }

&#x20;         }

&#x20;       },

&#x20;       "children": \[

&#x20;         {

&#x20;           "type": "container",

&#x20;           "properties": {

&#x20;             "padding": {

&#x20;               "edgeInsets": {

&#x20;                 "top": 0,

&#x20;                 "right": 0,

&#x20;                 "bottom": 0,

&#x20;                 "left": 0,

&#x20;                 "token": "lg"

&#x20;               }

&#x20;             },

&#x20;             "border": {

&#x20;               "borderSided": {

&#x20;                 "side": "bottom",

&#x20;                 "width": 1,

&#x20;                 "color": "divider"

&#x20;               }

&#x20;             }

&#x20;           },

&#x20;           "children": \[

&#x20;             {

&#x20;               "type": "row",

&#x20;               "properties": {

&#x20;                 "align": {

&#x20;                   "align": {

&#x20;                     "named": "space\_between"

&#x20;                   }

&#x20;                 }

&#x20;               },

&#x20;               "children": \[

&#x20;                 {

&#x20;                   "type": "iconbutton",

&#x20;                   "properties": {

&#x20;                     "name": {

&#x20;                       "icon": {

&#x20;                         "name": "arrow\_back\_rounded"

&#x20;                       }

&#x20;                     },

&#x20;                     "color": {

&#x20;                       "color": {

&#x20;                         "color": "primary\_text"

&#x20;                       }

&#x20;                     },

&#x20;                     "on\_tap": {

&#x20;                       "stringVal": {

&#x20;                         "value": "navigate:Dashboard"

&#x20;                       }

&#x20;                     }

&#x20;                   },

&#x20;                   "editorId": "iconbutton5"

&#x20;                 },

&#x20;                 {

&#x20;                   "type": "text",

&#x20;                   "properties": {

&#x20;                     "content": {

&#x20;                       "stringVal": {

&#x20;                         "value": "New Tracker"

&#x20;                       }

&#x20;                     },

&#x20;                     "style": {

&#x20;                       "textStyle": {

&#x20;                         "styleName": "title\_large"

&#x20;                       }

&#x20;                     },

&#x20;                     "font\_weight": {

&#x20;                       "stringVal": {

&#x20;                         "value": "bold"

&#x20;                       }

&#x20;                     }

&#x20;                   },

&#x20;                   "editorId": "text59"

&#x20;                 },

&#x20;                 {

&#x20;                   "type": "@std.button",

&#x20;                   "properties": {

&#x20;                     "content": {

&#x20;                       "stringVal": {

&#x20;                         "value": "Save"

&#x20;                       }

&#x20;                     },

&#x20;                     "variant": {

&#x20;                       "stringVal": {

&#x20;                         "value": "ghost"

&#x20;                       }

&#x20;                     },

&#x20;                     "size": {

&#x20;                       "stringVal": {

&#x20;                         "value": "small"

&#x20;                       }

&#x20;                     }

&#x20;                   },

&#x20;                   "editorId": "stdbutton2"

&#x20;                 }

&#x20;               ],

&#x20;               "editorId": "row29"

&#x20;             }

&#x20;           ],

&#x20;           "editorId": "container37"

&#x20;         },

&#x20;         {

&#x20;           "type": "column",

&#x20;           "properties": {

&#x20;             "padding": {

&#x20;               "edgeInsets": {

&#x20;                 "top": 0,

&#x20;                 "right": 0,

&#x20;                 "bottom": 0,

&#x20;                 "left": 0,

&#x20;                 "token": "lg"

&#x20;               }

&#x20;             },

&#x20;             "spacing": {

&#x20;               "stringVal": {

&#x20;                 "value": "xl"

&#x20;               }

&#x20;             }

&#x20;           },

&#x20;           "children": \[

&#x20;             {

&#x20;               "type": "column",

&#x20;               "properties": {

&#x20;                 "cross\_align": {

&#x20;                   "align": {

&#x20;                     "named": "stretch"

&#x20;                   }

&#x20;                 },

&#x20;                 "spacing": {

&#x20;                   "stringVal": {

&#x20;                     "value": "md"

&#x20;                   }

&#x20;                 }

&#x20;               },

&#x20;               "children": \[

&#x20;                 {

&#x20;                   "type": "@form\_section\_header",

&#x20;                   "properties": {

&#x20;                     "title": {

&#x20;                       "stringVal": {

&#x20;                         "value": "Type"

&#x20;                       }

&#x20;                     }

&#x20;                   },

&#x20;                   "editorId": "formsectionheader1"

&#x20;                 },

&#x20;                 {

&#x20;                   "type": "row",

&#x20;                   "properties": {

&#x20;                     "spacing": {

&#x20;                       "stringVal": {

&#x20;                         "value": "md"

&#x20;                       }

&#x20;                     }

&#x20;                   },

&#x20;                   "children": \[

&#x20;                     {

&#x20;                       "type": "@selection\_chip",

&#x20;                       "properties": {

&#x20;                         "label": {

&#x20;                           "stringVal": {

&#x20;                             "value": "Habit"

&#x20;                           }

&#x20;                         },

&#x20;                         "icon": {

&#x20;                           "stringVal": {

&#x20;                             "value": "check\_circle\_outline\_rounded"

&#x20;                           }

&#x20;                         },

&#x20;                         "selected": {

&#x20;                           "boolVal": {

&#x20;                             "value": true

&#x20;                           }

&#x20;                         }

&#x20;                       },

&#x20;                       "editorId": "selectionchip1"

&#x20;                     },

&#x20;                     {

&#x20;                       "type": "@selection\_chip",

&#x20;                       "properties": {

&#x20;                         "label": {

&#x20;                           "stringVal": {

&#x20;                             "value": "Counter"

&#x20;                           }

&#x20;                         },

&#x20;                         "icon": {

&#x20;                           "stringVal": {

&#x20;                             "value": "add\_circle\_outline\_rounded"

&#x20;                           }

&#x20;                         },

&#x20;                         "selected": {

&#x20;                           "boolVal": {

&#x20;                             "value": false

&#x20;                           }

&#x20;                         }

&#x20;                       },

&#x20;                       "editorId": "selectionchip2"

&#x20;                     }

&#x20;                   ],

&#x20;                   "editorId": "row30"

&#x20;                 },

&#x20;                 {

&#x20;                   "type": "row",

&#x20;                   "properties": {

&#x20;                     "spacing": {

&#x20;                       "stringVal": {

&#x20;                         "value": "md"

&#x20;                       }

&#x20;                     }

&#x20;                   },

&#x20;                   "children": \[

&#x20;                     {

&#x20;                       "type": "@selection\_chip",

&#x20;                       "properties": {

&#x20;                         "label": {

&#x20;                           "stringVal": {

&#x20;                             "value": "Goal"

&#x20;                           }

&#x20;                         },

&#x20;                         "icon": {

&#x20;                           "stringVal": {

&#x20;                             "value": "flag\_rounded"

&#x20;                           }

&#x20;                         },

&#x20;                         "selected": {

&#x20;                           "boolVal": {

&#x20;                             "value": false

&#x20;                           }

&#x20;                         }

&#x20;                       },

&#x20;                       "editorId": "selectionchip3"

&#x20;                     },

&#x20;                     {

&#x20;                       "type": "@selection\_chip",

&#x20;                       "properties": {

&#x20;                         "label": {

&#x20;                           "stringVal": {

&#x20;                             "value": "Timer"

&#x20;                           }

&#x20;                         },

&#x20;                         "icon": {

&#x20;                           "stringVal": {

&#x20;                             "value": "timer\_rounded"

&#x20;                           }

&#x20;                         },

&#x20;                         "selected": {

&#x20;                           "boolVal": {

&#x20;                             "value": false

&#x20;                           }

&#x20;                         }

&#x20;                       },

&#x20;                       "editorId": "selectionchip4"

&#x20;                     }

&#x20;                   ],

&#x20;                   "editorId": "row31"

&#x20;                 }

&#x20;               ],

&#x20;               "editorId": "column36"

&#x20;             },

&#x20;             {

&#x20;               "type": "column",

&#x20;               "properties": {

&#x20;                 "cross\_align": {

&#x20;                   "align": {

&#x20;                     "named": "stretch"

&#x20;                   }

&#x20;                 },

&#x20;                 "spacing": {

&#x20;                   "stringVal": {

&#x20;                     "value": "md"

&#x20;                   }

&#x20;                 }

&#x20;               },

&#x20;               "children": \[

&#x20;                 {

&#x20;                   "type": "@form\_section\_header",

&#x20;                   "properties": {

&#x20;                     "title": {

&#x20;                       "stringVal": {

&#x20;                         "value": "Identity"

&#x20;                       }

&#x20;                     }

&#x20;                   },

&#x20;                   "editorId": "formsectionheader2"

&#x20;                 },

&#x20;                 {

&#x20;                   "type": "@std.textfield",

&#x20;                   "properties": {

&#x20;                     "label": {

&#x20;                       "stringVal": {

&#x20;                         "value": "Name"

&#x20;                       }

&#x20;                     },

&#x20;                     "hint": {

&#x20;                       "stringVal": {

&#x20;                         "value": "e.g., Morning Meditation"

&#x20;                       }

&#x20;                     },

&#x20;                     "variant": {

&#x20;                       "stringVal": {

&#x20;                         "value": "outlined"

&#x20;                       }

&#x20;                     }

&#x20;                   },

&#x20;                   "editorId": "textfield1"

&#x20;                 },

&#x20;                 {

&#x20;                   "type": "row",

&#x20;                   "properties": {

&#x20;                     "spacing": {

&#x20;                       "stringVal": {

&#x20;                         "value": "md"

&#x20;                       }

&#x20;                     }

&#x20;                   },

&#x20;                   "children": \[

&#x20;                     {

&#x20;                       "type": "expanded",

&#x20;                       "children": \[

&#x20;                         {

&#x20;                           "type": "dropdown",

&#x20;                           "properties": {

&#x20;                             "label": {

&#x20;                               "stringVal": {

&#x20;                                 "value": "Category"

&#x20;                               }

&#x20;                             },

&#x20;                             "options": {

&#x20;                               "stringVal": {

&#x20;                                 "value": "Mindfulness,Health,Productivity,Fitness,Nutrition"

&#x20;                               }

&#x20;                             },

&#x20;                             "value": {

&#x20;                               "stringVal": {

&#x20;                                 "value": "Mindfulness"

&#x20;                               }

&#x20;                             },

&#x20;                             "radius": {

&#x20;                               "radius": {

&#x20;                                 "topLeft": 0,

&#x20;                                 "topRight": 0,

&#x20;                                 "bottomLeft": 0,

&#x20;                                 "bottomRight": 0,

&#x20;                                 "token": "lg"

&#x20;                               }

&#x20;                             }

&#x20;                           },

&#x20;                           "editorId": "dropdown1"

&#x20;                         }

&#x20;                       ],

&#x20;                       "editorId": "expanded9"

&#x20;                     },

&#x20;                     {

&#x20;                       "type": "container",

&#x20;                       "properties": {

&#x20;                         "width": {

&#x20;                           "px": {

&#x20;                             "value": 56,

&#x20;                             "isInfinity": false

&#x20;                           }

&#x20;                         },

&#x20;                         "height": {

&#x20;                           "px": {

&#x20;                             "value": 56,

&#x20;                             "isInfinity": false

&#x20;                           }

&#x20;                         },

&#x20;                         "bg": {

&#x20;                           "color": {

&#x20;                             "color": "surface"

&#x20;                           }

&#x20;                         },

&#x20;                         "radius": {

&#x20;                           "radius": {

&#x20;                             "topLeft": 0,

&#x20;                             "topRight": 0,

&#x20;                             "bottomLeft": 0,

&#x20;                             "bottomRight": 0,

&#x20;                             "token": "lg"

&#x20;                           }

&#x20;                         },

&#x20;                         "border": {

&#x20;                           "border": {

&#x20;                             "width": 1,

&#x20;                             "color": "divider"

&#x20;                           }

&#x20;                         },

&#x20;                         "align\_child": {

&#x20;                           "align": {

&#x20;                             "named": "center"

&#x20;                           }

&#x20;                         }

&#x20;                       },

&#x20;                       "children": \[

&#x20;                         {

&#x20;                           "type": "icon",

&#x20;                           "properties": {

&#x20;                             "name": {

&#x20;                               "icon": {

&#x20;                                 "name": "self\_improvement\_rounded"

&#x20;                               }

&#x20;                             },

&#x20;                             "color": {

&#x20;                               "color": {

&#x20;                                 "color": "primary"

&#x20;                               }

&#x20;                             },

&#x20;                             "size": {

&#x20;                               "numberVal": {

&#x20;                                 "value": 24

&#x20;                               }

&#x20;                             }

&#x20;                           },

&#x20;                           "editorId": "icon22"

&#x20;                         }

&#x20;                       ],

&#x20;                       "editorId": "container38"

&#x20;                     }

&#x20;                   ],

&#x20;                   "editorId": "row32"

&#x20;                 }

&#x20;               ],

&#x20;               "editorId": "column37"

&#x20;             },

&#x20;             {

&#x20;               "type": "column",

&#x20;               "properties": {

&#x20;                 "cross\_align": {

&#x20;                   "align": {

&#x20;                     "named": "stretch"

&#x20;                   }

&#x20;                 },

&#x20;                 "spacing": {

&#x20;                   "stringVal": {

&#x20;                     "value": "md"

&#x20;                   }

&#x20;                 }

&#x20;               },

&#x20;               "children": \[

&#x20;                 {

&#x20;                   "type": "@form\_section\_header",

&#x20;                   "properties": {

&#x20;                     "title": {

&#x20;                       "stringVal": {

&#x20;                         "value": "Configuration"

&#x20;                       }

&#x20;                     }

&#x20;                   },

&#x20;                   "editorId": "formsectionheader3"

&#x20;                 },

&#x20;                 {

&#x20;                   "type": "container",

&#x20;                   "properties": {

&#x20;                     "bg": {

&#x20;                       "color": {

&#x20;                         "color": "surface"

&#x20;                       }

&#x20;                     },

&#x20;                     "radius": {

&#x20;                       "radius": {

&#x20;                         "topLeft": 0,

&#x20;                         "topRight": 0,

&#x20;                         "bottomLeft": 0,

&#x20;                         "bottomRight": 0,

&#x20;                         "token": "lg"

&#x20;                       }

&#x20;                     },

&#x20;                     "padding": {

&#x20;                       "edgeInsets": {

&#x20;                         "top": 0,

&#x20;                         "right": 0,

&#x20;                         "bottom": 0,

&#x20;                         "left": 0,

&#x20;                         "token": "lg"

&#x20;                       }

&#x20;                     },

&#x20;                     "border": {

&#x20;                       "border": {

&#x20;                         "width": 1,

&#x20;                         "color": "divider"

&#x20;                       }

&#x20;                     }

&#x20;                   },

&#x20;                   "children": \[

&#x20;                     {

&#x20;                       "type": "column",

&#x20;                       "properties": {

&#x20;                         "spacing": {

&#x20;                           "stringVal": {

&#x20;                             "value": "lg"

&#x20;                           }

&#x20;                         },

&#x20;                         "cross\_align": {

&#x20;                           "align": {

&#x20;                             "named": "stretch"

&#x20;                           }

&#x20;                         }

&#x20;                       },

&#x20;                       "children": \[

&#x20;                         {

&#x20;                           "type": "row",

&#x20;                           "properties": {

&#x20;                             "align": {

&#x20;                               "align": {

&#x20;                                 "named": "space\_between"

&#x20;                               }

&#x20;                             }

&#x20;                           },

&#x20;                           "children": \[

&#x20;                             {

&#x20;                               "type": "text",

&#x20;                               "properties": {

&#x20;                                 "content": {

&#x20;                                   "stringVal": {

&#x20;                                     "value": "Frequency"

&#x20;                                   }

&#x20;                                 },

&#x20;                                 "style": {

&#x20;                                   "textStyle": {

&#x20;                                     "styleName": "body\_medium"

&#x20;                                   }

&#x20;                                 },

&#x20;                                 "color": {

&#x20;                                   "color": {

&#x20;                                     "color": "primary\_text"

&#x20;                                   }

&#x20;                                 }

&#x20;                               },

&#x20;                               "editorId": "text60"

&#x20;                             },

&#x20;                             {

&#x20;                               "type": "row",

&#x20;                               "properties": {

&#x20;                                 "spacing": {

&#x20;                                   "stringVal": {

&#x20;                                     "value": "xs"

&#x20;                                   }

&#x20;                                 }

&#x20;                               },

&#x20;                               "children": \[

&#x20;                                 {

&#x20;                                   "type": "chip",

&#x20;                                   "properties": {

&#x20;                                     "content": {

&#x20;                                       "stringVal": {

&#x20;                                         "value": "Daily"

&#x20;                                       }

&#x20;                                     },

&#x20;                                     "selected": {

&#x20;                                       "boolVal": {

&#x20;                                         "value": true

&#x20;                                       }

&#x20;                                     },

&#x20;                                     "variant": {

&#x20;                                       "stringVal": {

&#x20;                                         "value": "choice"

&#x20;                                       }

&#x20;                                     }

&#x20;                                   },

&#x20;                                   "editorId": "chip2"

&#x20;                                 },

&#x20;                                 {

&#x20;                                   "type": "chip",

&#x20;                                   "properties": {

&#x20;                                     "content": {

&#x20;                                       "stringVal": {

&#x20;                                         "value": "Weekly"

&#x20;                                       }

&#x20;                                     },

&#x20;                                     "selected": {

&#x20;                                       "boolVal": {

&#x20;                                         "value": false

&#x20;                                       }

&#x20;                                     },

&#x20;                                     "variant": {

&#x20;                                       "stringVal": {

&#x20;                                         "value": "choice"

&#x20;                                       }

&#x20;                                     }

&#x20;                                   },

&#x20;                                   "editorId": "chip3"

&#x20;                                 }

&#x20;                               ],

&#x20;                               "editorId": "row34"

&#x20;                             }

&#x20;                           ],

&#x20;                           "editorId": "row33"

&#x20;                         },

&#x20;                         {

&#x20;                           "type": "divider",

&#x20;                           "properties": {

&#x20;                             "color": {

&#x20;                               "color": {

&#x20;                                 "color": "divider"

&#x20;                               }

&#x20;                             }

&#x20;                           },

&#x20;                           "editorId": "divider3"

&#x20;                         },

&#x20;                         {

&#x20;                           "type": "column",

&#x20;                           "properties": {

&#x20;                             "spacing": {

&#x20;                               "stringVal": {

&#x20;                                 "value": "sm"

&#x20;                               }

&#x20;                             },

&#x20;                             "cross\_align": {

&#x20;                               "align": {

&#x20;                                 "named": "stretch"

&#x20;                               }

&#x20;                             }

&#x20;                           },

&#x20;                           "children": \[

&#x20;                             {

&#x20;                               "type": "text",

&#x20;                               "properties": {

&#x20;                                 "content": {

&#x20;                                   "stringVal": {

&#x20;                                     "value": "Target Value"

&#x20;                                   }

&#x20;                                 },

&#x20;                                 "style": {

&#x20;                                   "textStyle": {

&#x20;                                     "styleName": "label\_medium"

&#x20;                                   }

&#x20;                                 },

&#x20;                                 "color": {

&#x20;                                   "color": {

&#x20;                                     "color": "secondary\_text"

&#x20;                                   }

&#x20;                                 }

&#x20;                               },

&#x20;                               "editorId": "text61"

&#x20;                             },

&#x20;                             {

&#x20;                               "type": "row",

&#x20;                               "properties": {

&#x20;                                 "spacing": {

&#x20;                                   "stringVal": {

&#x20;                                     "value": "md"

&#x20;                                   }

&#x20;                                 }

&#x20;                               },

&#x20;                               "children": \[

&#x20;                                 {

&#x20;                                   "type": "expanded",

&#x20;                                   "children": \[

&#x20;                                     {

&#x20;                                       "type": "@std.textfield",

&#x20;                                       "properties": {

&#x20;                                         "value": {

&#x20;                                           "stringVal": {

&#x20;                                             "value": "1"

&#x20;                                           }

&#x20;                                         },

&#x20;                                         "variant": {

&#x20;                                           "stringVal": {

&#x20;                                             "value": "filled"

&#x20;                                           }

&#x20;                                         }

&#x20;                                       },

&#x20;                                       "editorId": "textfield2"

&#x20;                                     }

&#x20;                                   ],

&#x20;                                   "editorId": "expanded11"

&#x20;                                 },

&#x20;                                 {

&#x20;                                   "type": "text",

&#x20;                                   "properties": {

&#x20;                                     "content": {

&#x20;                                       "stringVal": {

&#x20;                                         "value": "per day"

&#x20;                                       }

&#x20;                                     },

&#x20;                                     "style": {

&#x20;                                       "textStyle": {

&#x20;                                         "styleName": "body\_medium"

&#x20;                                       }

&#x20;                                     },

&#x20;                                     "color": {

&#x20;                                       "color": {

&#x20;                                         "color": "secondary\_text"

&#x20;                                       }

&#x20;                                     }

&#x20;                                   },

&#x20;                                   "editorId": "text62"

&#x20;                                 }

&#x20;                               ],

&#x20;                               "editorId": "row35"

&#x20;                             }

&#x20;                           ],

&#x20;                           "editorId": "column40"

&#x20;                         }

&#x20;                       ],

&#x20;                       "editorId": "column39"

&#x20;                     }

&#x20;                   ],

&#x20;                   "editorId": "container39"

&#x20;                 }

&#x20;               ],

&#x20;               "editorId": "column38"

&#x20;             },

&#x20;             {

&#x20;               "type": "column",

&#x20;               "properties": {

&#x20;                 "cross\_align": {

&#x20;                   "align": {

&#x20;                     "named": "stretch"

&#x20;                   }

&#x20;                 },

&#x20;                 "spacing": {

&#x20;                   "stringVal": {

&#x20;                     "value": "md"

&#x20;                   }

&#x20;                 }

&#x20;               },

&#x20;               "children": \[

&#x20;                 {

&#x20;                   "type": "@form\_section\_header",

&#x20;                   "properties": {

&#x20;                     "title": {

&#x20;                       "stringVal": {

&#x20;                         "value": "Reminders"

&#x20;                       }

&#x20;                     }

&#x20;                   },

&#x20;                   "editorId": "formsectionheader4"

&#x20;                 },

&#x20;                 {

&#x20;                   "type": "container",

&#x20;                   "properties": {

&#x20;                     "bg": {

&#x20;                       "color": {

&#x20;                         "color": "surface"

&#x20;                       }

&#x20;                     },

&#x20;                     "radius": {

&#x20;                       "radius": {

&#x20;                         "topLeft": 0,

&#x20;                         "topRight": 0,

&#x20;                         "bottomLeft": 0,

&#x20;                         "bottomRight": 0,

&#x20;                         "token": "lg"

&#x20;                       }

&#x20;                     },

&#x20;                     "padding": {

&#x20;                       "edgeInsets": {

&#x20;                         "top": 0,

&#x20;                         "right": 0,

&#x20;                         "bottom": 0,

&#x20;                         "left": 0,

&#x20;                         "token": "lg"

&#x20;                       }

&#x20;                     },

&#x20;                     "border": {

&#x20;                       "border": {

&#x20;                         "width": 1,

&#x20;                         "color": "divider"

&#x20;                       }

&#x20;                     }

&#x20;                   },

&#x20;                   "children": \[

&#x20;                     {

&#x20;                       "type": "column",

&#x20;                       "properties": {

&#x20;                         "spacing": {

&#x20;                           "stringVal": {

&#x20;                             "value": "md"

&#x20;                           }

&#x20;                         },

&#x20;                         "cross\_align": {

&#x20;                           "align": {

&#x20;                             "named": "stretch"

&#x20;                           }

&#x20;                         }

&#x20;                       },

&#x20;                       "children": \[

&#x20;                         {

&#x20;                           "type": "@std.switch",

&#x20;                           "properties": {

&#x20;                             "label": {

&#x20;                               "stringVal": {

&#x20;                                 "value": "Enable Notifications"

&#x20;                               }

&#x20;                             },

&#x20;                             "active": {

&#x20;                               "boolVal": {

&#x20;                                 "value": true

&#x20;                               }

&#x20;                             }

&#x20;                           },

&#x20;                           "editorId": "switch1"

&#x20;                         },

&#x20;                         {

&#x20;                           "type": "row",

&#x20;                           "properties": {

&#x20;                             "align": {

&#x20;                               "align": {

&#x20;                                 "named": "space\_between"

&#x20;                               }

&#x20;                             }

&#x20;                           },

&#x20;                           "children": \[

&#x20;                             {

&#x20;                               "type": "row",

&#x20;                               "properties": {

&#x20;                                 "spacing": {

&#x20;                                   "stringVal": {

&#x20;                                     "value": "sm"

&#x20;                                   }

&#x20;                                 }

&#x20;                               },

&#x20;                               "children": \[

&#x20;                                 {

&#x20;                                   "type": "icon",

&#x20;                                   "properties": {

&#x20;                                     "name": {

&#x20;                                       "icon": {

&#x20;                                         "name": "access\_time\_rounded"

&#x20;                                       }

&#x20;                                     },

&#x20;                                     "size": {

&#x20;                                       "numberVal": {

&#x20;                                         "value": 20

&#x20;                                       }

&#x20;                                     },

&#x20;                                     "color": {

&#x20;                                       "color": {

&#x20;                                         "color": "secondary\_text"

&#x20;                                       }

&#x20;                                     }

&#x20;                                   },

&#x20;                                   "editorId": "icon23"

&#x20;                                 },

&#x20;                                 {

&#x20;                                   "type": "text",

&#x20;                                   "properties": {

&#x20;                                     "content": {

&#x20;                                       "stringVal": {

&#x20;                                         "value": "08:30 AM"

&#x20;                                       }

&#x20;                                     },

&#x20;                                     "style": {

&#x20;                                       "textStyle": {

&#x20;                                         "styleName": "body\_large"

&#x20;                                       }

&#x20;                                     },

&#x20;                                     "font\_weight": {

&#x20;                                       "numberVal": {

&#x20;                                         "value": 600

&#x20;                                       }

&#x20;                                     }

&#x20;                                   },

&#x20;                                   "editorId": "text63"

&#x20;                                 }

&#x20;                               ],

&#x20;                               "editorId": "row37"

&#x20;                             },

&#x20;                             {

&#x20;                               "type": "@std.button",

&#x20;                               "properties": {

&#x20;                                 "content": {

&#x20;                                   "stringVal": {

&#x20;                                     "value": "Add Time"

&#x20;                                   }

&#x20;                                 },

&#x20;                                 "variant": {

&#x20;                                   "stringVal": {

&#x20;                                     "value": "outline"

&#x20;                                   }

&#x20;                                 },

&#x20;                                 "size": {

&#x20;                                   "stringVal": {

&#x20;                                     "value": "small"

&#x20;                                   }

&#x20;                                 },

&#x20;                                 "icon": {

&#x20;                                   "stringVal": {

&#x20;                                     "value": "add\_rounded"

&#x20;                                   }

&#x20;                                 }

&#x20;                               },

&#x20;                               "editorId": "stdbutton3"

&#x20;                             }

&#x20;                           ],

&#x20;                           "editorId": "row36"

&#x20;                         }

&#x20;                       ],

&#x20;                       "editorId": "column42"

&#x20;                     }

&#x20;                   ],

&#x20;                   "editorId": "container40"

&#x20;                 }

&#x20;               ],

&#x20;               "editorId": "column41"

&#x20;             },

&#x20;             {

&#x20;               "type": "column",

&#x20;               "properties": {

&#x20;                 "spacing": {

&#x20;                   "stringVal": {

&#x20;                     "value": "md"

&#x20;                   }

&#x20;                 },

&#x20;                 "padding": {

&#x20;                   "edgeInsets": {

&#x20;                     "top": 0,

&#x20;                     "right": 0,

&#x20;                     "bottom": 0,

&#x20;                     "left": 0,

&#x20;                     "bottomToken": "xl"

&#x20;                   }

&#x20;                 }

&#x20;               },

&#x20;               "children": \[

&#x20;                 {

&#x20;                   "type": "@std.button",

&#x20;                   "properties": {

&#x20;                     "content": {

&#x20;                       "stringVal": {

&#x20;                         "value": "Create Tracker"

&#x20;                       }

&#x20;                     },

&#x20;                     "variant": {

&#x20;                       "stringVal": {

&#x20;                         "value": "primary"

&#x20;                       }

&#x20;                     },

&#x20;                     "full\_width": {

&#x20;                       "boolVal": {

&#x20;                         "value": true

&#x20;                       }

&#x20;                     },

&#x20;                     "size": {

&#x20;                       "stringVal": {

&#x20;                         "value": "large"

&#x20;                       }

&#x20;                     }

&#x20;                   },

&#x20;                   "editorId": "button3"

&#x20;                 },

&#x20;                 {

&#x20;                   "type": "@std.button",

&#x20;                   "properties": {

&#x20;                     "content": {

&#x20;                       "stringVal": {

&#x20;                         "value": "Cancel"

&#x20;                       }

&#x20;                     },

&#x20;                     "variant": {

&#x20;                       "stringVal": {

&#x20;                         "value": "ghost"

&#x20;                       }

&#x20;                     },

&#x20;                     "full\_width": {

&#x20;                       "boolVal": {

&#x20;                         "value": true

&#x20;                       }

&#x20;                     },

&#x20;                     "color": {

&#x20;                       "stringVal": {

&#x20;                         "value": "secondary\_text"

&#x20;                       }

&#x20;                     },

&#x20;                     "on\_tap": {

&#x20;                       "stringVal": {

&#x20;                         "value": "navigate:Dashboard"

&#x20;                       }

&#x20;                     }

&#x20;                   },

&#x20;                   "editorId": "button4"

&#x20;                 }

&#x20;               ],

&#x20;               "editorId": "column43"

&#x20;             }

&#x20;           ],

&#x20;           "editorId": "column35"

&#x20;         }

&#x20;       ],

&#x20;       "editorId": "column34"

&#x20;     }

&#x20;   ],

&#x20;   "editorId": "scaffold3"

&#x20; }

}

```



\### 4. Tracker Detail



\- Frame ID: `frame7`

\- Original page prompt: "Detailed stats for a specific tracker featuring a GitHub-style heatmap, trend charts, and activity history."

\- Follow-up prompts: \_None\_



\#### DslDocument (JSON)



```json

{

&#x20; "root": {

&#x20;   "type": "scaffold",

&#x20;   "properties": {

&#x20;     "bg": {

&#x20;       "color": {

&#x20;         "color": "background"

&#x20;       }

&#x20;     },

&#x20;     "safe\_area": {

&#x20;       "boolVal": {

&#x20;         "value": true

&#x20;       }

&#x20;     }

&#x20;   },

&#x20;   "children": \[

&#x20;     {

&#x20;       "type": "column",

&#x20;       "properties": {

&#x20;         "scroll": {

&#x20;           "boolVal": {

&#x20;             "value": true

&#x20;           }

&#x20;         },

&#x20;         "cross\_align": {

&#x20;           "align": {

&#x20;             "named": "stretch"

&#x20;           }

&#x20;         }

&#x20;       },

&#x20;       "children": \[

&#x20;         {

&#x20;           "type": "container",

&#x20;           "properties": {

&#x20;             "padding": {

&#x20;               "edgeInsets": {

&#x20;                 "top": 0,

&#x20;                 "right": 0,

&#x20;                 "bottom": 0,

&#x20;                 "left": 0,

&#x20;                 "token": "lg"

&#x20;               }

&#x20;             },

&#x20;             "bg": {

&#x20;               "color": {

&#x20;                 "color": "surface"

&#x20;               }

&#x20;             },

&#x20;             "border": {

&#x20;               "borderSided": {

&#x20;                 "side": "bottom",

&#x20;                 "width": 1,

&#x20;                 "color": "divider"

&#x20;               }

&#x20;             }

&#x20;           },

&#x20;           "children": \[

&#x20;             {

&#x20;               "type": "row",

&#x20;               "properties": {

&#x20;                 "align": {

&#x20;                   "align": {

&#x20;                     "named": "space\_between"

&#x20;                   }

&#x20;                 }

&#x20;               },

&#x20;               "children": \[

&#x20;                 {

&#x20;                   "type": "iconbutton",

&#x20;                   "properties": {

&#x20;                     "name": {

&#x20;                       "icon": {

&#x20;                         "name": "arrow\_back\_rounded"

&#x20;                       }

&#x20;                     },

&#x20;                     "color": {

&#x20;                       "color": {

&#x20;                         "color": "primary\_text"

&#x20;                       }

&#x20;                     },

&#x20;                     "on\_tap": {

&#x20;                       "stringVal": {

&#x20;                         "value": "navigate:Dashboard"

&#x20;                       }

&#x20;                     }

&#x20;                   },

&#x20;                   "editorId": "iconbutton6"

&#x20;                 },

&#x20;                 {

&#x20;                   "type": "text",

&#x20;                   "properties": {

&#x20;                     "content": {

&#x20;                       "stringVal": {

&#x20;                         "value": "Deep Work"

&#x20;                       }

&#x20;                     },

&#x20;                     "style": {

&#x20;                       "textStyle": {

&#x20;                         "styleName": "title\_large"

&#x20;                       }

&#x20;                     },

&#x20;                     "font\_weight": {

&#x20;                       "stringVal": {

&#x20;                         "value": "bold"

&#x20;                       }

&#x20;                     }

&#x20;                   },

&#x20;                   "editorId": "text71"

&#x20;                 },

&#x20;                 {

&#x20;                   "type": "row",

&#x20;                   "properties": {

&#x20;                     "spacing": {

&#x20;                       "stringVal": {

&#x20;                         "value": "sm"

&#x20;                       }

&#x20;                     }

&#x20;                   },

&#x20;                   "children": \[

&#x20;                     {

&#x20;                       "type": "iconbutton",

&#x20;                       "properties": {

&#x20;                         "name": {

&#x20;                           "icon": {

&#x20;                             "name": "edit\_rounded"

&#x20;                           }

&#x20;                         },

&#x20;                         "color": {

&#x20;                           "color": {

&#x20;                             "color": "primary\_text"

&#x20;                           }

&#x20;                         },

&#x20;                         "on\_tap": {

&#x20;                           "stringVal": {

&#x20;                             "value": "navigate:AddTracker"

&#x20;                           }

&#x20;                         }

&#x20;                       },

&#x20;                       "editorId": "iconbutton7"

&#x20;                     },

&#x20;                     {

&#x20;                       "type": "iconbutton",

&#x20;                       "properties": {

&#x20;                         "name": {

&#x20;                           "icon": {

&#x20;                             "name": "delete\_outline\_rounded"

&#x20;                           }

&#x20;                         },

&#x20;                         "color": {

&#x20;                           "color": {

&#x20;                             "color": "error"

&#x20;                           }

&#x20;                         }

&#x20;                       },

&#x20;                       "editorId": "iconbutton8"

&#x20;                     }

&#x20;                   ],

&#x20;                   "editorId": "row39"

&#x20;                 }

&#x20;               ],

&#x20;               "editorId": "row38"

&#x20;             }

&#x20;           ],

&#x20;           "editorId": "container41"

&#x20;         },

&#x20;         {

&#x20;           "type": "container",

&#x20;           "properties": {

&#x20;             "padding": {

&#x20;               "edgeInsets": {

&#x20;                 "top": 0,

&#x20;                 "right": 0,

&#x20;                 "bottom": 0,

&#x20;                 "left": 0,

&#x20;                 "token": "lg"

&#x20;               }

&#x20;             },

&#x20;             "spacing": {

&#x20;               "stringVal": {

&#x20;                 "value": "lg"

&#x20;               }

&#x20;             }

&#x20;           },

&#x20;           "children": \[

&#x20;             {

&#x20;               "type": "row",

&#x20;               "properties": {

&#x20;                 "spacing": {

&#x20;                   "stringVal": {

&#x20;                     "value": "md"

&#x20;                   }

&#x20;                 }

&#x20;               },

&#x20;               "children": \[

&#x20;                 {

&#x20;                   "type": "container",

&#x20;                   "properties": {

&#x20;                     "width": {

&#x20;                       "px": {

&#x20;                         "value": 64,

&#x20;                         "isInfinity": false

&#x20;                       }

&#x20;                     },

&#x20;                     "height": {

&#x20;                       "px": {

&#x20;                         "value": 64,

&#x20;                         "isInfinity": false

&#x20;                       }

&#x20;                     },

&#x20;                     "radius": {

&#x20;                       "radius": {

&#x20;                         "topLeft": 0,

&#x20;                         "topRight": 0,

&#x20;                         "bottomLeft": 0,

&#x20;                         "bottomRight": 0,

&#x20;                         "token": "lg"

&#x20;                       }

&#x20;                     },

&#x20;                     "bg": {

&#x20;                       "color": {

&#x20;                         "color": "primary",

&#x20;                         "opacityPercent": 10

&#x20;                       }

&#x20;                     },

&#x20;                     "align\_child": {

&#x20;                       "align": {

&#x20;                         "named": "center"

&#x20;                       }

&#x20;                     }

&#x20;                   },

&#x20;                   "children": \[

&#x20;                     {

&#x20;                       "type": "icon",

&#x20;                       "properties": {

&#x20;                         "name": {

&#x20;                           "icon": {

&#x20;                             "name": "focus\_rounded"

&#x20;                           }

&#x20;                         },

&#x20;                         "color": {

&#x20;                           "color": {

&#x20;                             "color": "on\_primary"

&#x20;                           }

&#x20;                         },

&#x20;                         "size": {

&#x20;                           "numberVal": {

&#x20;                             "value": 32

&#x20;                           }

&#x20;                         }

&#x20;                       },

&#x20;                       "editorId": "icon21"

&#x20;                     }

&#x20;                   ],

&#x20;                   "editorId": "container43"

&#x20;                 },

&#x20;                 {

&#x20;                   "type": "expanded",

&#x20;                   "children": \[

&#x20;                     {

&#x20;                       "type": "column",

&#x20;                       "properties": {

&#x20;                         "cross\_align": {

&#x20;                           "align": {

&#x20;                             "named": "start"

&#x20;                           }

&#x20;                         },

&#x20;                         "spacing": {

&#x20;                           "stringVal": {

&#x20;                             "value": "xs"

&#x20;                           }

&#x20;                         }

&#x20;                       },

&#x20;                       "children": \[

&#x20;                         {

&#x20;                           "type": "text",

&#x20;                           "properties": {

&#x20;                             "content": {

&#x20;                               "stringVal": {

&#x20;                                 "value": "Productivity"

&#x20;                               }

&#x20;                             },

&#x20;                             "style": {

&#x20;                               "textStyle": {

&#x20;                                 "styleName": "label\_medium"

&#x20;                               }

&#x20;                             },

&#x20;                             "color": {

&#x20;                               "color": {

&#x20;                                 "color": "primary"

&#x20;                               }

&#x20;                             }

&#x20;                           },

&#x20;                           "editorId": "text72"

&#x20;                         },

&#x20;                         {

&#x20;                           "type": "text",

&#x20;                           "properties": {

&#x20;                             "content": {

&#x20;                               "stringVal": {

&#x20;                                 "value": "Daily Goal: 4 Hours"

&#x20;                               }

&#x20;                             },

&#x20;                             "style": {

&#x20;                               "textStyle": {

&#x20;                                 "styleName": "body\_medium"

&#x20;                               }

&#x20;                             },

&#x20;                             "color": {

&#x20;                               "color": {

&#x20;                                 "color": "secondary\_text"

&#x20;                               }

&#x20;                             }

&#x20;                           },

&#x20;                           "editorId": "text73"

&#x20;                         }

&#x20;                       ],

&#x20;                       "editorId": "column45"

&#x20;                     }

&#x20;                   ],

&#x20;                   "editorId": "expanded13"

&#x20;                 }

&#x20;               ],

&#x20;               "editorId": "row40"

&#x20;             }

&#x20;           ],

&#x20;           "editorId": "container42"

&#x20;         },

&#x20;         {

&#x20;           "type": "row",

&#x20;           "properties": {

&#x20;             "padding": {

&#x20;               "edgeInsets": {

&#x20;                 "top": 0,

&#x20;                 "right": 0,

&#x20;                 "bottom": 0,

&#x20;                 "left": 0,

&#x20;                 "rightToken": "lg",

&#x20;                 "bottomToken": "md",

&#x20;                 "leftToken": "lg"

&#x20;               }

&#x20;             },

&#x20;             "spacing": {

&#x20;               "stringVal": {

&#x20;                 "value": "md"

&#x20;               }

&#x20;             }

&#x20;           },

&#x20;           "children": \[

&#x20;             {

&#x20;               "type": "@stat\_card",

&#x20;               "properties": {

&#x20;                 "label": {

&#x20;                   "stringVal": {

&#x20;                     "value": "Current Streak"

&#x20;                   }

&#x20;                 },

&#x20;                 "value": {

&#x20;                   "stringVal": {

&#x20;                     "value": "12 Days"

&#x20;                   }

&#x20;                 }

&#x20;               },

&#x20;               "editorId": "statcard1"

&#x20;             },

&#x20;             {

&#x20;               "type": "@stat\_card",

&#x20;               "properties": {

&#x20;                 "label": {

&#x20;                   "stringVal": {

&#x20;                     "value": "Best Streak"

&#x20;                   }

&#x20;                 },

&#x20;                 "value": {

&#x20;                   "stringVal": {

&#x20;                     "value": "24 Days"

&#x20;                   }

&#x20;                 }

&#x20;               },

&#x20;               "editorId": "statcard2"

&#x20;             },

&#x20;             {

&#x20;               "type": "@stat\_card",

&#x20;               "properties": {

&#x20;                 "label": {

&#x20;                   "stringVal": {

&#x20;                     "value": "Completion"

&#x20;                   }

&#x20;                 },

&#x20;                 "value": {

&#x20;                   "stringVal": {

&#x20;                     "value": "88%"

&#x20;                   }

&#x20;                 }

&#x20;               },

&#x20;               "editorId": "statcard3"

&#x20;             }

&#x20;           ],

&#x20;           "editorId": "row41"

&#x20;         },

&#x20;         {

&#x20;           "type": "column",

&#x20;           "properties": {

&#x20;             "padding": {

&#x20;               "edgeInsets": {

&#x20;                 "top": 0,

&#x20;                 "right": 0,

&#x20;                 "bottom": 0,

&#x20;                 "left": 0,

&#x20;                 "token": "lg"

&#x20;               }

&#x20;             },

&#x20;             "spacing": {

&#x20;               "stringVal": {

&#x20;                 "value": "md"

&#x20;               }

&#x20;             }

&#x20;           },

&#x20;           "children": \[

&#x20;             {

&#x20;               "type": "row",

&#x20;               "properties": {

&#x20;                 "align": {

&#x20;                   "align": {

&#x20;                     "named": "space\_between"

&#x20;                   }

&#x20;                 }

&#x20;               },

&#x20;               "children": \[

&#x20;                 {

&#x20;                   "type": "text",

&#x20;                   "properties": {

&#x20;                     "content": {

&#x20;                       "stringVal": {

&#x20;                         "value": "Activity (90 Days)"

&#x20;                       }

&#x20;                     },

&#x20;                     "style": {

&#x20;                       "textStyle": {

&#x20;                         "styleName": "title\_medium"

&#x20;                       }

&#x20;                     },

&#x20;                     "font\_weight": {

&#x20;                       "numberVal": {

&#x20;                         "value": 600

&#x20;                       }

&#x20;                     }

&#x20;                   },

&#x20;                   "editorId": "text74"

&#x20;                 },

&#x20;                 {

&#x20;                   "type": "text",

&#x20;                   "properties": {

&#x20;                     "content": {

&#x20;                       "stringVal": {

&#x20;                         "value": "Intensity"

&#x20;                       }

&#x20;                     },

&#x20;                     "style": {

&#x20;                       "textStyle": {

&#x20;                         "styleName": "label\_small"

&#x20;                       }

&#x20;                     },

&#x20;                     "color": {

&#x20;                       "color": {

&#x20;                         "color": "secondary\_text"

&#x20;                       }

&#x20;                     }

&#x20;                   },

&#x20;                   "editorId": "text75"

&#x20;                 }

&#x20;               ],

&#x20;               "editorId": "row42"

&#x20;             },

&#x20;             {

&#x20;               "type": "container",

&#x20;               "properties": {

&#x20;                 "bg": {

&#x20;                   "color": {

&#x20;                     "color": "surface"

&#x20;                   }

&#x20;                 },

&#x20;                 "radius": {

&#x20;                   "radius": {

&#x20;                     "topLeft": 0,

&#x20;                     "topRight": 0,

&#x20;                     "bottomLeft": 0,

&#x20;                     "bottomRight": 0,

&#x20;                     "token": "lg"

&#x20;                   }

&#x20;                 },

&#x20;                 "padding": {

&#x20;                   "edgeInsets": {

&#x20;                     "top": 0,

&#x20;                     "right": 0,

&#x20;                     "bottom": 0,

&#x20;                     "left": 0,

&#x20;                     "token": "md"

&#x20;                   }

&#x20;                 },

&#x20;                 "border": {

&#x20;                   "border": {

&#x20;                     "width": 1,

&#x20;                     "color": "divider"

&#x20;                   }

&#x20;                 }

&#x20;               },

&#x20;               "children": \[

&#x20;                 {

&#x20;                   "type": "column",

&#x20;                   "properties": {

&#x20;                     "spacing": {

&#x20;                       "stringVal": {

&#x20;                         "value": "xs"

&#x20;                       }

&#x20;                     }

&#x20;                   },

&#x20;                   "children": \[

&#x20;                     {

&#x20;                       "type": "row",

&#x20;                       "properties": {

&#x20;                         "spacing": {

&#x20;                           "numberVal": {

&#x20;                             "value": 4

&#x20;                           }

&#x20;                         },

&#x20;                         "align": {

&#x20;                           "align": {

&#x20;                             "named": "center"

&#x20;                           }

&#x20;                         }

&#x20;                       },

&#x20;                       "children": \[

&#x20;                         {

&#x20;                           "type": "container",

&#x20;                           "properties": {

&#x20;                             "width": {

&#x20;                               "px": {

&#x20;                                 "value": 10,

&#x20;                                 "isInfinity": false

&#x20;                               }

&#x20;                             },

&#x20;                             "height": {

&#x20;                               "px": {

&#x20;                                 "value": 10,

&#x20;                                 "isInfinity": false

&#x20;                               }

&#x20;                             },

&#x20;                             "radius": {

&#x20;                               "radius": {

&#x20;                                 "topLeft": 2,

&#x20;                                 "topRight": 2,

&#x20;                                 "bottomLeft": 2,

&#x20;                                 "bottomRight": 2

&#x20;                               }

&#x20;                             },

&#x20;                             "bg": {

&#x20;                               "color": {

&#x20;                                 "color": "primary",

&#x20;                                 "opacityPercent": 10

&#x20;                               }

&#x20;                             }

&#x20;                           },

&#x20;                           "editorId": "container45"

&#x20;                         },

&#x20;                         {

&#x20;                           "type": "container",

&#x20;                           "properties": {

&#x20;                             "width": {

&#x20;                               "px": {

&#x20;                                 "value": 10,

&#x20;                                 "isInfinity": false

&#x20;                               }

&#x20;                             },

&#x20;                             "height": {

&#x20;                               "px": {

&#x20;                                 "value": 10,

&#x20;                                 "isInfinity": false

&#x20;                               }

&#x20;                             },

&#x20;                             "radius": {

&#x20;                               "radius": {

&#x20;                                 "topLeft": 2,

&#x20;                                 "topRight": 2,

&#x20;                                 "bottomLeft": 2,

&#x20;                                 "bottomRight": 2

&#x20;                               }

&#x20;                             },

&#x20;                             "bg": {

&#x20;                               "color": {

&#x20;                                 "color": "primary",

&#x20;                                 "opacityPercent": 30

&#x20;                               }

&#x20;                             }

&#x20;                           },

&#x20;                           "editorId": "container46"

&#x20;                         },

&#x20;                         {

&#x20;                           "type": "container",

&#x20;                           "properties": {

&#x20;                             "width": {

&#x20;                               "px": {

&#x20;                                 "value": 10,

&#x20;                                 "isInfinity": false

&#x20;                               }

&#x20;                             },

&#x20;                             "height": {

&#x20;                               "px": {

&#x20;                                 "value": 10,

&#x20;                                 "isInfinity": false

&#x20;                               }

&#x20;                             },

&#x20;                             "radius": {

&#x20;                               "radius": {

&#x20;                                 "topLeft": 2,

&#x20;                                 "topRight": 2,

&#x20;                                 "bottomLeft": 2,

&#x20;                                 "bottomRight": 2

&#x20;                               }

&#x20;                             },

&#x20;                             "bg": {

&#x20;                               "color": {

&#x20;                                 "color": "primary",

&#x20;                                 "opacityPercent": 60

&#x20;                               }

&#x20;                             }

&#x20;                           },

&#x20;                           "editorId": "container47"

&#x20;                         },

&#x20;                         {

&#x20;                           "type": "container",

&#x20;                           "properties": {

&#x20;                             "width": {

&#x20;                               "px": {

&#x20;                                 "value": 10,

&#x20;                                 "isInfinity": false

&#x20;                               }

&#x20;                             },

&#x20;                             "height": {

&#x20;                               "px": {

&#x20;                                 "value": 10,

&#x20;                                 "isInfinity": false

&#x20;                               }

&#x20;                             },

&#x20;                             "radius": {

&#x20;                               "radius": {

&#x20;                                 "topLeft": 2,

&#x20;                                 "topRight": 2,

&#x20;                                 "bottomLeft": 2,

&#x20;                                 "bottomRight": 2

&#x20;                               }

&#x20;                             },

&#x20;                             "bg": {

&#x20;                               "color": {

&#x20;                                 "color": "primary",

&#x20;                                 "opacityPercent": 90

&#x20;                               }

&#x20;                             }

&#x20;                           },

&#x20;                           "editorId": "container48"

&#x20;                         },

&#x20;                         {

&#x20;                           "type": "container",

&#x20;                           "properties": {

&#x20;                             "width": {

&#x20;                               "px": {

&#x20;                                 "value": 10,

&#x20;                                 "isInfinity": false

&#x20;                               }

&#x20;                             },

&#x20;                             "height": {

&#x20;                               "px": {

&#x20;                                 "value": 10,

&#x20;                                 "isInfinity": false

&#x20;                               }

&#x20;                             },

&#x20;                             "radius": {

&#x20;                               "radius": {

&#x20;                                 "topLeft": 2,

&#x20;                                 "topRight": 2,

&#x20;                                 "bottomLeft": 2,

&#x20;                                 "bottomRight": 2

&#x20;                               }

&#x20;                             },

&#x20;                             "bg": {

&#x20;                               "color": {

&#x20;                                 "color": "primary"

&#x20;                               }

&#x20;                             }

&#x20;                           },

&#x20;                           "editorId": "container49"

&#x20;                         },

&#x20;                         {

&#x20;                           "type": "text",

&#x20;                           "properties": {

&#x20;                             "content": {

&#x20;                               "stringVal": {

&#x20;                                 "value": "Less"

&#x20;                               }

&#x20;                             },

&#x20;                             "style": {

&#x20;                               "textStyle": {

&#x20;                                 "styleName": "label\_small"

&#x20;                               }

&#x20;                             },

&#x20;                             "color": {

&#x20;                               "color": {

&#x20;                                 "color": "on\_surface"

&#x20;                               }

&#x20;                             },

&#x20;                             "margin": {

&#x20;                               "edgeInsets": {

&#x20;                                 "top": 0,

&#x20;                                 "right": 0,

&#x20;                                 "bottom": 0,

&#x20;                                 "left": 0,

&#x20;                                 "leftToken": "sm"

&#x20;                               }

&#x20;                             }

&#x20;                           },

&#x20;                           "editorId": "text76"

&#x20;                         },

&#x20;                         {

&#x20;                           "type": "text",

&#x20;                           "properties": {

&#x20;                             "content": {

&#x20;                               "stringVal": {

&#x20;                                 "value": "More"

&#x20;                               }

&#x20;                             },

&#x20;                             "style": {

&#x20;                               "textStyle": {

&#x20;                                 "styleName": "label\_small"

&#x20;                               }

&#x20;                             },

&#x20;                             "color": {

&#x20;                               "color": {

&#x20;                                 "color": "on\_surface"

&#x20;                               }

&#x20;                             },

&#x20;                             "margin": {

&#x20;                               "edgeInsets": {

&#x20;                                 "top": 0,

&#x20;                                 "right": 0,

&#x20;                                 "bottom": 0,

&#x20;                                 "left": 0,

&#x20;                                 "rightToken": "sm"

&#x20;                               }

&#x20;                             }

&#x20;                           },

&#x20;                           "editorId": "text77"

&#x20;                         }

&#x20;                       ],

&#x20;                       "editorId": "row43"

&#x20;                     },

&#x20;                     {

&#x20;                       "type": "grid",

&#x20;                       "properties": {

&#x20;                         "columns": {

&#x20;                           "numberVal": {

&#x20;                             "value": 10

&#x20;                           }

&#x20;                         },

&#x20;                         "spacing": {

&#x20;                           "numberVal": {

&#x20;                             "value": 4

&#x20;                           }

&#x20;                         },

&#x20;                         "run\_spacing": {

&#x20;                           "numberVal": {

&#x20;                             "value": 4

&#x20;                           }

&#x20;                         },

&#x20;                         "shrink\_wrap": {

&#x20;                           "boolVal": {

&#x20;                             "value": true

&#x20;                           }

&#x20;                         }

&#x20;                       },

&#x20;                       "children": \[

&#x20;                         {

&#x20;                           "type": "container",

&#x20;                           "properties": {

&#x20;                             "width": {

&#x20;                               "px": {

&#x20;                                 "value": 10,

&#x20;                                 "isInfinity": false

&#x20;                               }

&#x20;                             },

&#x20;                             "height": {

&#x20;                               "px": {

&#x20;                                 "value": 10,

&#x20;                                 "isInfinity": false

&#x20;                               }

&#x20;                             },

&#x20;                             "radius": {

&#x20;                               "radius": {

&#x20;                                 "topLeft": 2,

&#x20;                                 "topRight": 2,

&#x20;                                 "bottomLeft": 2,

&#x20;                                 "bottomRight": 2

&#x20;                               }

&#x20;                             },

&#x20;                             "bg": {

&#x20;                               "color": {

&#x20;                                 "color": "primary",

&#x20;                                 "opacityPercent": 10

&#x20;                               }

&#x20;                             }

&#x20;                           },

&#x20;                           "editorId": "container50"

&#x20;                         },

&#x20;                         {

&#x20;                           "type": "container",

&#x20;                           "properties": {

&#x20;                             "width": {

&#x20;                               "px": {

&#x20;                                 "value": 10,

&#x20;                                 "isInfinity": false

&#x20;                               }

&#x20;                             },

&#x20;                             "height": {

&#x20;                               "px": {

&#x20;                                 "value": 10,

&#x20;                                 "isInfinity": false

&#x20;                               }

&#x20;                             },

&#x20;                             "radius": {

&#x20;                               "radius": {

&#x20;                                 "topLeft": 2,

&#x20;                                 "topRight": 2,

&#x20;                                 "bottomLeft": 2,

&#x20;                                 "bottomRight": 2

&#x20;                               }

&#x20;                             },

&#x20;                             "bg": {

&#x20;                               "color": {

&#x20;                                 "color": "primary",

&#x20;                                 "opacityPercent": 40

&#x20;                               }

&#x20;                             }

&#x20;                           },

&#x20;                           "editorId": "container51"

&#x20;                         },

&#x20;                         {

&#x20;                           "type": "container",

&#x20;                           "properties": {

&#x20;                             "width": {

&#x20;                               "px": {

&#x20;                                 "value": 10,

&#x20;                                 "isInfinity": false

&#x20;                               }

&#x20;                             },

&#x20;                             "height": {

&#x20;                               "px": {

&#x20;                                 "value": 10,

&#x20;                                 "isInfinity": false

&#x20;                               }

&#x20;                             },

&#x20;                             "radius": {

&#x20;                               "radius": {

&#x20;                                 "topLeft": 2,

&#x20;                                 "topRight": 2,

&#x20;                                 "bottomLeft": 2,

&#x20;                                 "bottomRight": 2

&#x20;                               }

&#x20;                             },

&#x20;                             "bg": {

&#x20;                               "color": {

&#x20;                                 "color": "primary",

&#x20;                                 "opacityPercent": 20

&#x20;                               }

&#x20;                             }

&#x20;                           },

&#x20;                           "editorId": "container52"

&#x20;                         },

&#x20;                         {

&#x20;                           "type": "container",

&#x20;                           "properties": {

&#x20;                             "width": {

&#x20;                               "px": {

&#x20;                                 "value": 10,

&#x20;                                 "isInfinity": false

&#x20;                               }

&#x20;                             },

&#x20;                             "height": {

&#x20;                               "px": {

&#x20;                                 "value": 10,

&#x20;                                 "isInfinity": false

&#x20;                               }

&#x20;                             },

&#x20;                             "radius": {

&#x20;                               "radius": {

&#x20;                                 "topLeft": 2,

&#x20;                                 "topRight": 2,

&#x20;                                 "bottomLeft": 2,

&#x20;                                 "bottomRight": 2

&#x20;                               }

&#x20;                             },

&#x20;                             "bg": {

&#x20;                               "color": {

&#x20;                                 "color": "primary",

&#x20;                                 "opacityPercent": 80

&#x20;                               }

&#x20;                             }

&#x20;                           },

&#x20;                           "editorId": "container53"

&#x20;                         },

&#x20;                         {

&#x20;                           "type": "container",

&#x20;                           "properties": {

&#x20;                             "width": {

&#x20;                               "px": {

&#x20;                                 "value": 10,

&#x20;                                 "isInfinity": false

&#x20;                               }

&#x20;                             },

&#x20;                             "height": {

&#x20;                               "px": {

&#x20;                                 "value": 10,

&#x20;                                 "isInfinity": false

&#x20;                               }

&#x20;                             },

&#x20;                             "radius": {

&#x20;                               "radius": {

&#x20;                                 "topLeft": 2,

&#x20;                                 "topRight": 2,

&#x20;                                 "bottomLeft": 2,

&#x20;                                 "bottomRight": 2

&#x20;                               }

&#x20;                             },

&#x20;                             "bg": {

&#x20;                               "color": {

&#x20;                                 "color": "primary",

&#x20;                                 "opacityPercent": 50

&#x20;                               }

&#x20;                             }

&#x20;                           },

&#x20;                           "editorId": "container54"

&#x20;                         },

&#x20;                         {

&#x20;                           "type": "container",

&#x20;                           "properties": {

&#x20;                             "width": {

&#x20;                               "px": {

&#x20;                                 "value": 10,

&#x20;                                 "isInfinity": false

&#x20;                               }

&#x20;                             },

&#x20;                             "height": {

&#x20;                               "px": {

&#x20;                                 "value": 10,

&#x20;                                 "isInfinity": false

&#x20;                               }

&#x20;                             },

&#x20;                             "radius": {

&#x20;                               "radius": {

&#x20;                                 "topLeft": 2,

&#x20;                                 "topRight": 2,

&#x20;                                 "bottomLeft": 2,

&#x20;                                 "bottomRight": 2

&#x20;                               }

&#x20;                             },

&#x20;                             "bg": {

&#x20;                               "color": {

&#x20;                                 "color": "primary",

&#x20;                                 "opacityPercent": 10

&#x20;                               }

&#x20;                             }

&#x20;                           },

&#x20;                           "editorId": "container55"

&#x20;                         },

&#x20;                         {

&#x20;                           "type": "container",

&#x20;                           "properties": {

&#x20;                             "width": {

&#x20;                               "px": {

&#x20;                                 "value": 10,

&#x20;                                 "isInfinity": false

&#x20;                               }

&#x20;                             },

&#x20;                             "height": {

&#x20;                               "px": {

&#x20;                                 "value": 10,

&#x20;                                 "isInfinity": false

&#x20;                               }

&#x20;                             },

&#x20;                             "radius": {

&#x20;                               "radius": {

&#x20;                                 "topLeft": 2,

&#x20;                                 "topRight": 2,

&#x20;                                 "bottomLeft": 2,

&#x20;                                 "bottomRight": 2

&#x20;                               }

&#x20;                             },

&#x20;                             "bg": {

&#x20;                               "color": {

&#x20;                                 "color": "primary",

&#x20;                                 "opacityPercent": 90

&#x20;                               }

&#x20;                             }

&#x20;                           },

&#x20;                           "editorId": "container56"

&#x20;                         },

&#x20;                         {

&#x20;                           "type": "container",

&#x20;                           "properties": {

&#x20;                             "width": {

&#x20;                               "px": {

&#x20;                                 "value": 10,

&#x20;                                 "isInfinity": false

&#x20;                               }

&#x20;                             },

&#x20;                             "height": {

&#x20;                               "px": {

&#x20;                                 "value": 10,

&#x20;                                 "isInfinity": false

&#x20;                               }

&#x20;                             },

&#x20;                             "radius": {

&#x20;                               "radius": {

&#x20;                                 "topLeft": 2,

&#x20;                                 "topRight": 2,

&#x20;                                 "bottomLeft": 2,

&#x20;                                 "bottomRight": 2

&#x20;                               }

&#x20;                             },

&#x20;                             "bg": {

&#x20;                               "color": {

&#x20;                                 "color": "primary",

&#x20;                                 "opacityPercent": 30

&#x20;                               }

&#x20;                             }

&#x20;                           },

&#x20;                           "editorId": "container57"

&#x20;                         },

&#x20;                         {

&#x20;                           "type": "container",

&#x20;                           "properties": {

&#x20;                             "width": {

&#x20;                               "px": {

&#x20;                                 "value": 10,

&#x20;                                 "isInfinity": false

&#x20;                               }

&#x20;                             },

&#x20;                             "height": {

&#x20;                               "px": {

&#x20;                                 "value": 10,

&#x20;                                 "isInfinity": false

&#x20;                               }

&#x20;                             },

&#x20;                             "radius": {

&#x20;                               "radius": {

&#x20;                                 "topLeft": 2,

&#x20;                                 "topRight": 2,

&#x20;                                 "bottomLeft": 2,

&#x20;                                 "bottomRight": 2

&#x20;                               }

&#x20;                             },

&#x20;                             "bg": {

&#x20;                               "color": {

&#x20;                                 "color": "primary",

&#x20;                                 "opacityPercent": 60

&#x20;                               }

&#x20;                             }

&#x20;                           },

&#x20;                           "editorId": "container58"

&#x20;                         },

&#x20;                         {

&#x20;                           "type": "container",

&#x20;                           "properties": {

&#x20;                             "width": {

&#x20;                               "px": {

&#x20;                                 "value": 10,

&#x20;                                 "isInfinity": false

&#x20;                               }

&#x20;                             },

&#x20;                             "height": {

&#x20;                               "px": {

&#x20;                                 "value": 10,

&#x20;                                 "isInfinity": false

&#x20;                               }

&#x20;                             },

&#x20;                             "radius": {

&#x20;                               "radius": {

&#x20;                                 "topLeft": 2,

&#x20;                                 "topRight": 2,

&#x20;                                 "bottomLeft": 2,

&#x20;                                 "bottomRight": 2

&#x20;                               }

&#x20;                             },

&#x20;                             "bg": {

&#x20;                               "color": {

&#x20;                                 "color": "primary",

&#x20;                                 "opacityPercent": 20

&#x20;                               }

&#x20;                             }

&#x20;                           },

&#x20;                           "editorId": "container59"

&#x20;                         },

&#x20;                         {

&#x20;                           "type": "container",

&#x20;                           "properties": {

&#x20;                             "width": {

&#x20;                               "px": {

&#x20;                                 "value": 10,

&#x20;                                 "isInfinity": false

&#x20;                               }

&#x20;                             },

&#x20;                             "height": {

&#x20;                               "px": {

&#x20;                                 "value": 10,

&#x20;                                 "isInfinity": false

&#x20;                               }

&#x20;                             },

&#x20;                             "radius": {

&#x20;                               "radius": {

&#x20;                                 "topLeft": 2,

&#x20;                                 "topRight": 2,

&#x20;                                 "bottomLeft": 2,

&#x20;                                 "bottomRight": 2

&#x20;                               }

&#x20;                             },

&#x20;                             "bg": {

&#x20;                               "color": {

&#x20;                                 "color": "primary",

&#x20;                                 "opacityPercent": 10

&#x20;                               }

&#x20;                             }

&#x20;                           },

&#x20;                           "editorId": "container60"

&#x20;                         },

&#x20;                         {

&#x20;                           "type": "container",

&#x20;                           "properties": {

&#x20;                             "width": {

&#x20;                               "px": {

&#x20;                                 "value": 10,

&#x20;                                 "isInfinity": false

&#x20;                               }

&#x20;                             },

&#x20;                             "height": {

&#x20;                               "px": {

&#x20;                                 "value": 10,

&#x20;                                 "isInfinity": false

&#x20;                               }

&#x20;                             },

&#x20;                             "radius": {

&#x20;                               "radius": {

&#x20;                                 "topLeft": 2,

&#x20;                                 "topRight": 2,

&#x20;                                 "bottomLeft": 2,

&#x20;                                 "bottomRight": 2

&#x20;                               }

&#x20;                             },

&#x20;                             "bg": {

&#x20;                               "color": {

&#x20;                                 "color": "primary",

&#x20;                                 "opacityPercent": 40

&#x20;                               }

&#x20;                             }

&#x20;                           },

&#x20;                           "editorId": "container61"

&#x20;                         },

&#x20;                         {

&#x20;                           "type": "container",

&#x20;                           "properties": {

&#x20;                             "width": {

&#x20;                               "px": {

&#x20;                                 "value": 10,

&#x20;                                 "isInfinity": false

&#x20;                               }

&#x20;                             },

&#x20;                             "height": {

&#x20;                               "px": {

&#x20;                                 "value": 10,

&#x20;                                 "isInfinity": false

&#x20;                               }

&#x20;                             },

&#x20;                             "radius": {

&#x20;                               "radius": {

&#x20;                                 "topLeft": 2,

&#x20;                                 "topRight": 2,

&#x20;                                 "bottomLeft": 2,

&#x20;                                 "bottomRight": 2

&#x20;                               }

&#x20;                             },

&#x20;                             "bg": {

&#x20;                               "color": {

&#x20;                                 "color": "primary",

&#x20;                                 "opacityPercent": 70

&#x20;                               }

&#x20;                             }

&#x20;                           },

&#x20;                           "editorId": "container62"

&#x20;                         },

&#x20;                         {

&#x20;                           "type": "container",

&#x20;                           "properties": {

&#x20;                             "width": {

&#x20;                               "px": {

&#x20;                                 "value": 10,

&#x20;                                 "isInfinity": false

&#x20;                               }

&#x20;                             },

&#x20;                             "height": {

&#x20;                               "px": {

&#x20;                                 "value": 10,

&#x20;                                 "isInfinity": false

&#x20;                               }

&#x20;                             },

&#x20;                             "radius": {

&#x20;                               "radius": {

&#x20;                                 "topLeft": 2,

&#x20;                                 "topRight": 2,

&#x20;                                 "bottomLeft": 2,

&#x20;                                 "bottomRight": 2

&#x20;                               }

&#x20;                             },

&#x20;                             "bg": {

&#x20;                               "color": {

&#x20;                                 "color": "primary",

&#x20;                                 "opacityPercent": 90

&#x20;                               }

&#x20;                             }

&#x20;                           },

&#x20;                           "editorId": "container63"

&#x20;                         },

&#x20;                         {

&#x20;                           "type": "container",

&#x20;                           "properties": {

&#x20;                             "width": {

&#x20;                               "px": {

&#x20;                                 "value": 10,

&#x20;                                 "isInfinity": false

&#x20;                               }

&#x20;                             },

&#x20;                             "height": {

&#x20;                               "px": {

&#x20;                                 "value": 10,

&#x20;                                 "isInfinity": false

&#x20;                               }

&#x20;                             },

&#x20;                             "radius": {

&#x20;                               "radius": {

&#x20;                                 "topLeft": 2,

&#x20;                                 "topRight": 2,

&#x20;                                 "bottomLeft": 2,

&#x20;                                 "bottomRight": 2

&#x20;                               }

&#x20;                             },

&#x20;                             "bg": {

&#x20;                               "color": {

&#x20;                                 "color": "primary",

&#x20;                                 "opacityPercent": 50

&#x20;                               }

&#x20;                             }

&#x20;                           },

&#x20;                           "editorId": "container64"

&#x20;                         },

&#x20;                         {

&#x20;                           "type": "container",

&#x20;                           "properties": {

&#x20;                             "width": {

&#x20;                               "px": {

&#x20;                                 "value": 10,

&#x20;                                 "isInfinity": false

&#x20;                               }

&#x20;                             },

&#x20;                             "height": {

&#x20;                               "px": {

&#x20;                                 "value": 10,

&#x20;                                 "isInfinity": false

&#x20;                               }

&#x20;                             },

&#x20;                             "radius": {

&#x20;                               "radius": {

&#x20;                                 "topLeft": 2,

&#x20;                                 "topRight": 2,

&#x20;                                 "bottomLeft": 2,

&#x20;                                 "bottomRight": 2

&#x20;                               }

&#x20;                             },

&#x20;                             "bg": {

&#x20;                               "color": {

&#x20;                                 "color": "primary",

&#x20;                                 "opacityPercent": 30

&#x20;                               }

&#x20;                             }

&#x20;                           },

&#x20;                           "editorId": "container65"

&#x20;                         },

&#x20;                         {

&#x20;                           "type": "container",

&#x20;                           "properties": {

&#x20;                             "width": {

&#x20;                               "px": {

&#x20;                                 "value": 10,

&#x20;                                 "isInfinity": false

&#x20;                               }

&#x20;                             },

&#x20;                             "height": {

&#x20;                               "px": {

&#x20;                                 "value": 10,

&#x20;                                 "isInfinity": false

&#x20;                               }

&#x20;                             },

&#x20;                             "radius": {

&#x20;                               "radius": {

&#x20;                                 "topLeft": 2,

&#x20;                                 "topRight": 2,

&#x20;                                 "bottomLeft": 2,

&#x20;                                 "bottomRight": 2

&#x20;                               }

&#x20;                             },

&#x20;                             "bg": {

&#x20;                               "color": {

&#x20;                                 "color": "primary",

&#x20;                                 "opacityPercent": 10

&#x20;                               }

&#x20;                             }

&#x20;                           },

&#x20;                           "editorId": "container66"

&#x20;                         },

&#x20;                         {

&#x20;                           "type": "container",

&#x20;                           "properties": {

&#x20;                             "width": {

&#x20;                               "px": {

&#x20;                                 "value": 10,

&#x20;                                 "isInfinity": false

&#x20;                               }

&#x20;                             },

&#x20;                             "height": {

&#x20;                               "px": {

&#x20;                                 "value": 10,

&#x20;                                 "isInfinity": false

&#x20;                               }

&#x20;                             },

&#x20;                             "radius": {

&#x20;                               "radius": {

&#x20;                                 "topLeft": 2,

&#x20;                                 "topRight": 2,

&#x20;                                 "bottomLeft": 2,

&#x20;                                 "bottomRight": 2

&#x20;                               }

&#x20;                             },

&#x20;                             "bg": {

&#x20;                               "color": {

&#x20;                                 "color": "primary",

&#x20;                                 "opacityPercent": 80

&#x20;                               }

&#x20;                             }

&#x20;                           },

&#x20;                           "editorId": "container67"

&#x20;                         },

&#x20;                         {

&#x20;                           "type": "container",

&#x20;                           "properties": {

&#x20;                             "width": {

&#x20;                               "px": {

&#x20;                                 "value": 10,

&#x20;                                 "isInfinity": false

&#x20;                               }

&#x20;                             },

&#x20;                             "height": {

&#x20;                               "px": {

&#x20;                                 "value": 10,

&#x20;                                 "isInfinity": false

&#x20;                               }

&#x20;                             },

&#x20;                             "radius": {

&#x20;                               "radius": {

&#x20;                                 "topLeft": 2,

&#x20;                                 "topRight": 2,

&#x20;                                 "bottomLeft": 2,

&#x20;                                 "bottomRight": 2

&#x20;                               }

&#x20;                             },

&#x20;                             "bg": {

&#x20;                               "color": {

&#x20;                                 "color": "primary",

&#x20;                                 "opacityPercent": 40

&#x20;                               }

&#x20;                             }

&#x20;                           },

&#x20;                           "editorId": "container68"

&#x20;                         },

&#x20;                         {

&#x20;                           "type": "container",

&#x20;                           "properties": {

&#x20;                             "width": {

&#x20;                               "px": {

&#x20;                                 "value": 10,

&#x20;                                 "isInfinity": false

&#x20;                               }

&#x20;                             },

&#x20;                             "height": {

&#x20;                               "px": {

&#x20;                                 "value": 10,

&#x20;                                 "isInfinity": false

&#x20;                               }

&#x20;                             },

&#x20;                             "radius": {

&#x20;                               "radius": {

&#x20;                                 "topLeft": 2,

&#x20;                                 "topRight": 2,

&#x20;                                 "bottomLeft": 2,

&#x20;                                 "bottomRight": 2

&#x20;                               }

&#x20;                             },

&#x20;                             "bg": {

&#x20;                               "color": {

&#x20;                                 "color": "primary",

&#x20;                                 "opacityPercent": 20

&#x20;                               }

&#x20;                             }

&#x20;                           },

&#x20;                           "editorId": "container69"

&#x20;                         }

&#x20;                       ],

&#x20;                       "editorId": "grid1"

&#x20;                     }

&#x20;                   ],

&#x20;                   "editorId": "column47"

&#x20;                 }

&#x20;               ],

&#x20;               "editorId": "container44"

&#x20;             }

&#x20;           ],

&#x20;           "editorId": "column46"

&#x20;         },

&#x20;         {

&#x20;           "type": "column",

&#x20;           "properties": {

&#x20;             "padding": {

&#x20;               "edgeInsets": {

&#x20;                 "top": 0,

&#x20;                 "right": 0,

&#x20;                 "bottom": 0,

&#x20;                 "left": 0,

&#x20;                 "token": "lg"

&#x20;               }

&#x20;             },

&#x20;             "spacing": {

&#x20;               "stringVal": {

&#x20;                 "value": "md"

&#x20;               }

&#x20;             }

&#x20;           },

&#x20;           "children": \[

&#x20;             {

&#x20;               "type": "row",

&#x20;               "properties": {

&#x20;                 "align": {

&#x20;                   "align": {

&#x20;                     "named": "space\_between"

&#x20;                   }

&#x20;                 }

&#x20;               },

&#x20;               "children": \[

&#x20;                 {

&#x20;                   "type": "text",

&#x20;                   "properties": {

&#x20;                     "content": {

&#x20;                       "stringVal": {

&#x20;                         "value": "Weekly Trend"

&#x20;                       }

&#x20;                     },

&#x20;                     "style": {

&#x20;                       "textStyle": {

&#x20;                         "styleName": "title\_medium"

&#x20;                       }

&#x20;                     },

&#x20;                     "font\_weight": {

&#x20;                       "numberVal": {

&#x20;                         "value": 600

&#x20;                       }

&#x20;                     }

&#x20;                   },

&#x20;                   "editorId": "text78"

&#x20;                 },

&#x20;                 {

&#x20;                   "type": "dropdown",

&#x20;                   "properties": {

&#x20;                     "options": {

&#x20;                       "stringVal": {

&#x20;                         "value": "7D,30D,90D"

&#x20;                       }

&#x20;                     },

&#x20;                     "value": {

&#x20;                       "stringVal": {

&#x20;                         "value": "7D"

&#x20;                       }

&#x20;                     },

&#x20;                     "radius": {

&#x20;                       "radius": {

&#x20;                         "topLeft": 0,

&#x20;                         "topRight": 0,

&#x20;                         "bottomLeft": 0,

&#x20;                         "bottomRight": 0,

&#x20;                         "token": "md"

&#x20;                       }

&#x20;                     },

&#x20;                     "bg": {

&#x20;                       "color": {

&#x20;                         "color": "surface"

&#x20;                       }

&#x20;                     },

&#x20;                     "padding": {

&#x20;                       "edgeInsets": {

&#x20;                         "top": 4,

&#x20;                         "right": 8,

&#x20;                         "bottom": 4,

&#x20;                         "left": 8

&#x20;                       }

&#x20;                     },

&#x20;                     "expanded": {

&#x20;                       "expanded": {

&#x20;                         "enabled": true,

&#x20;                         "flex": 1

&#x20;                       }

&#x20;                     }

&#x20;                   },

&#x20;                   "editorId": "dropdown2"

&#x20;                 }

&#x20;               ],

&#x20;               "editorId": "row44"

&#x20;             },

&#x20;             {

&#x20;               "type": "container",

&#x20;               "properties": {

&#x20;                 "height": {

&#x20;                   "px": {

&#x20;                     "value": 200,

&#x20;                     "isInfinity": false

&#x20;                   }

&#x20;                 },

&#x20;                 "bg": {

&#x20;                   "color": {

&#x20;                     "color": "surface"

&#x20;                   }

&#x20;                 },

&#x20;                 "radius": {

&#x20;                   "radius": {

&#x20;                     "topLeft": 0,

&#x20;                     "topRight": 0,

&#x20;                     "bottomLeft": 0,

&#x20;                     "bottomRight": 0,

&#x20;                     "token": "lg"

&#x20;                   }

&#x20;                 },

&#x20;                 "padding": {

&#x20;                   "edgeInsets": {

&#x20;                     "top": 0,

&#x20;                     "right": 0,

&#x20;                     "bottom": 0,

&#x20;                     "left": 0,

&#x20;                     "token": "md"

&#x20;                   }

&#x20;                 },

&#x20;                 "border": {

&#x20;                   "border": {

&#x20;                     "width": 1,

&#x20;                     "color": "divider"

&#x20;                   }

&#x20;                 }

&#x20;               },

&#x20;               "children": \[

&#x20;                 {

&#x20;                   "type": "line\_chart",

&#x20;                   "properties": {

&#x20;                     "data": {

&#x20;                       "stringVal": {

&#x20;                         "value": "2,4,3,5,4,6,4"

&#x20;                       }

&#x20;                     },

&#x20;                     "labels": {

&#x20;                       "stringVal": {

&#x20;                         "value": "M,T,W,T,F,S,S"

&#x20;                       }

&#x20;                     },

&#x20;                     "color": {

&#x20;                       "color": {

&#x20;                         "color": "primary"

&#x20;                       }

&#x20;                     },

&#x20;                     "curved": {

&#x20;                       "boolVal": {

&#x20;                         "value": true

&#x20;                       }

&#x20;                     },

&#x20;                     "filled": {

&#x20;                       "boolVal": {

&#x20;                         "value": true

&#x20;                       }

&#x20;                     },

&#x20;                     "fill\_opacity": {

&#x20;                       "numberVal": {

&#x20;                         "value": 0.1

&#x20;                       }

&#x20;                     },

&#x20;                     "show\_dots": {

&#x20;                       "boolVal": {

&#x20;                         "value": true

&#x20;                       }

&#x20;                     }

&#x20;                   },

&#x20;                   "editorId": "linechart1"

&#x20;                 }

&#x20;               ],

&#x20;               "editorId": "container70"

&#x20;             }

&#x20;           ],

&#x20;           "editorId": "column48"

&#x20;         },

&#x20;         {

&#x20;           "type": "column",

&#x20;           "properties": {

&#x20;             "padding": {

&#x20;               "edgeInsets": {

&#x20;                 "top": 0,

&#x20;                 "right": 0,

&#x20;                 "bottom": 0,

&#x20;                 "left": 0,

&#x20;                 "token": "lg"

&#x20;               }

&#x20;             },

&#x20;             "spacing": {

&#x20;               "stringVal": {

&#x20;                 "value": "md"

&#x20;               }

&#x20;             }

&#x20;           },

&#x20;           "children": \[

&#x20;             {

&#x20;               "type": "text",

&#x20;               "properties": {

&#x20;                 "content": {

&#x20;                   "stringVal": {

&#x20;                     "value": "Recent Activity"

&#x20;                   }

&#x20;                 },

&#x20;                 "style": {

&#x20;                   "textStyle": {

&#x20;                     "styleName": "title\_medium"

&#x20;                   }

&#x20;                 },

&#x20;                 "font\_weight": {

&#x20;                   "numberVal": {

&#x20;                     "value": 600

&#x20;                   }

&#x20;                 }

&#x20;               },

&#x20;               "editorId": "text79"

&#x20;             },

&#x20;             {

&#x20;               "type": "column",

&#x20;               "properties": {

&#x20;                 "spacing": {

&#x20;                   "numberVal": {

&#x20;                     "value": 0

&#x20;                   }

&#x20;                 }

&#x20;               },

&#x20;               "children": \[

&#x20;                 {

&#x20;                   "type": "@log\_entry",

&#x20;                   "properties": {

&#x20;                     "note": {

&#x20;                       "stringVal": {

&#x20;                         "value": "Morning session"

&#x20;                       }

&#x20;                     },

&#x20;                     "value": {

&#x20;                       "stringVal": {

&#x20;                         "value": "1h 20m"

&#x20;                       }

&#x20;                     },

&#x20;                     "time": {

&#x20;                       "stringVal": {

&#x20;                         "value": "Today"

&#x20;                       }

&#x20;                     }

&#x20;                   },

&#x20;                   "editorId": "logentry1"

&#x20;                 },

&#x20;                 {

&#x20;                   "type": "@log\_entry",

&#x20;                   "properties": {

&#x20;                     "note": {

&#x20;                       "stringVal": {

&#x20;                         "value": "Focused on UI design"

&#x20;                       }

&#x20;                     },

&#x20;                     "value": {

&#x20;                       "stringVal": {

&#x20;                         "value": "2h 15m"

&#x20;                       }

&#x20;                     },

&#x20;                     "time": {

&#x20;                       "stringVal": {

&#x20;                         "value": "Yesterday"

&#x20;                       }

&#x20;                     }

&#x20;                   },

&#x20;                   "editorId": "logentry2"

&#x20;                 },

&#x20;                 {

&#x20;                   "type": "@log\_entry",

&#x20;                   "properties": {

&#x20;                     "note": {

&#x20;                       "stringVal": {

&#x20;                         "value": "Quick task"

&#x20;                       }

&#x20;                     },

&#x20;                     "value": {

&#x20;                       "stringVal": {

&#x20;                         "value": "45m"

&#x20;                       }

&#x20;                     },

&#x20;                     "time": {

&#x20;                       "stringVal": {

&#x20;                         "value": "2 days ago"

&#x20;                       }

&#x20;                     }

&#x20;                   },

&#x20;                   "editorId": "logentry3"

&#x20;                 },

&#x20;                 {

&#x20;                   "type": "@log\_entry",

&#x20;                   "properties": {

&#x20;                     "note": {

&#x20;                       "stringVal": {

&#x20;                         "value": "Deep work session"

&#x20;                       }

&#x20;                     },

&#x20;                     "value": {

&#x20;                       "stringVal": {

&#x20;                         "value": "3h 00m"

&#x20;                       }

&#x20;                     },

&#x20;                     "time": {

&#x20;                       "stringVal": {

&#x20;                         "value": "3 days ago"

&#x20;                       }

&#x20;                     }

&#x20;                   },

&#x20;                   "editorId": "logentry4"

&#x20;                 }

&#x20;               ],

&#x20;               "editorId": "column50"

&#x20;             }

&#x20;           ],

&#x20;           "editorId": "column49"

&#x20;         },

&#x20;         {

&#x20;           "type": "container",

&#x20;           "properties": {

&#x20;             "padding": {

&#x20;               "edgeInsets": {

&#x20;                 "top": 0,

&#x20;                 "right": 0,

&#x20;                 "bottom": 0,

&#x20;                 "left": 0,

&#x20;                 "token": "lg"

&#x20;               }

&#x20;             },

&#x20;             "margin": {

&#x20;               "edgeInsets": {

&#x20;                 "top": 0,

&#x20;                 "right": 0,

&#x20;                 "bottom": 0,

&#x20;                 "left": 0,

&#x20;                 "bottomToken": "xl"

&#x20;               }

&#x20;             }

&#x20;           },

&#x20;           "children": \[

&#x20;             {

&#x20;               "type": "@std.button",

&#x20;               "properties": {

&#x20;                 "content": {

&#x20;                   "stringVal": {

&#x20;                     "value": "Log Activity"

&#x20;                   }

&#x20;                 },

&#x20;                 "icon": {

&#x20;                   "stringVal": {

&#x20;                     "value": "add\_rounded"

&#x20;                   }

&#x20;                 },

&#x20;                 "variant": {

&#x20;                   "stringVal": {

&#x20;                     "value": "primary"

&#x20;                   }

&#x20;                 },

&#x20;                 "full\_width": {

&#x20;                   "boolVal": {

&#x20;                     "value": true

&#x20;                   }

&#x20;                 },

&#x20;                 "size": {

&#x20;                   "stringVal": {

&#x20;                     "value": "large"

&#x20;                   }

&#x20;                 }

&#x20;               },

&#x20;               "editorId": "stdbutton4"

&#x20;             }

&#x20;           ],

&#x20;           "editorId": "container71"

&#x20;         }

&#x20;       ],

&#x20;       "editorId": "column44"

&#x20;     }

&#x20;   ],

&#x20;   "editorId": "scaffold4"

&#x20; }

}

```



\### 5. Timer Session



\- Frame ID: `frame2`

\- Original page prompt: "Active countdown/count-up timer interface with start, pause, and stop controls for timed activities."

\- Follow-up prompts: \_None\_



\#### DslDocument (JSON)



```json

{

&#x20; "root": {

&#x20;   "type": "scaffold",

&#x20;   "properties": {

&#x20;     "bg": {

&#x20;       "color": {

&#x20;         "color": "background"

&#x20;       }

&#x20;     },

&#x20;     "safe\_area": {

&#x20;       "boolVal": {

&#x20;         "value": true

&#x20;       }

&#x20;     }

&#x20;   },

&#x20;   "children": \[

&#x20;     {

&#x20;       "type": "column",

&#x20;       "properties": {

&#x20;         "cross\_align": {

&#x20;           "align": {

&#x20;             "named": "stretch"

&#x20;           }

&#x20;         },

&#x20;         "padding": {

&#x20;           "edgeInsets": {

&#x20;             "top": 0,

&#x20;             "right": 0,

&#x20;             "bottom": 0,

&#x20;             "left": 0,

&#x20;             "token": "lg"

&#x20;           }

&#x20;         },

&#x20;         "spacing": {

&#x20;           "stringVal": {

&#x20;             "value": "xl"

&#x20;           }

&#x20;         }

&#x20;       },

&#x20;       "children": \[

&#x20;         {

&#x20;           "type": "row",

&#x20;           "properties": {

&#x20;             "align": {

&#x20;               "align": {

&#x20;                 "named": "space\_between"

&#x20;               }

&#x20;             },

&#x20;             "cross\_align": {

&#x20;               "align": {

&#x20;                 "named": "center"

&#x20;               }

&#x20;             }

&#x20;           },

&#x20;           "children": \[

&#x20;             {

&#x20;               "type": "iconbutton",

&#x20;               "properties": {

&#x20;                 "name": {

&#x20;                   "icon": {

&#x20;                     "name": "arrow\_back\_rounded"

&#x20;                   }

&#x20;                 },

&#x20;                 "on\_tap": {

&#x20;                   "stringVal": {

&#x20;                     "value": "navigate:Dashboard"

&#x20;                   }

&#x20;                 }

&#x20;               },

&#x20;               "editorId": "iconbutton10"

&#x20;             },

&#x20;             {

&#x20;               "type": "column",

&#x20;               "properties": {

&#x20;                 "cross\_align": {

&#x20;                   "align": {

&#x20;                     "named": "center"

&#x20;                   }

&#x20;                 },

&#x20;                 "spacing": {

&#x20;                   "stringVal": {

&#x20;                     "value": "xs"

&#x20;                   }

&#x20;                 }

&#x20;               },

&#x20;               "children": \[

&#x20;                 {

&#x20;                   "type": "text",

&#x20;                   "properties": {

&#x20;                     "content": {

&#x20;                       "stringVal": {

&#x20;                         "value": "Deep Work"

&#x20;                       }

&#x20;                     },

&#x20;                     "style": {

&#x20;                       "textStyle": {

&#x20;                         "styleName": "title\_medium"

&#x20;                       }

&#x20;                     },

&#x20;                     "font\_weight": {

&#x20;                       "stringVal": {

&#x20;                         "value": "bold"

&#x20;                       }

&#x20;                     }

&#x20;                   },

&#x20;                   "editorId": "text65"

&#x20;                 },

&#x20;                 {

&#x20;                   "type": "row",

&#x20;                   "properties": {

&#x20;                     "spacing": {

&#x20;                       "stringVal": {

&#x20;                         "value": "xs"

&#x20;                       }

&#x20;                     },

&#x20;                     "cross\_align": {

&#x20;                       "align": {

&#x20;                         "named": "center"

&#x20;                       }

&#x20;                     }

&#x20;                   },

&#x20;                   "children": \[

&#x20;                     {

&#x20;                       "type": "icon",

&#x20;                       "properties": {

&#x20;                         "name": {

&#x20;                           "icon": {

&#x20;                             "name": "schedule\_rounded"

&#x20;                           }

&#x20;                         },

&#x20;                         "size": {

&#x20;                           "numberVal": {

&#x20;                             "value": 14

&#x20;                           }

&#x20;                         },

&#x20;                         "color": {

&#x20;                           "color": {

&#x20;                             "color": "secondary\_text"

&#x20;                           }

&#x20;                         }

&#x20;                       },

&#x20;                       "editorId": "icon24"

&#x20;                     },

&#x20;                     {

&#x20;                       "type": "text",

&#x20;                       "properties": {

&#x20;                         "content": {

&#x20;                           "stringVal": {

&#x20;                             "value": "Target: 60 min"

&#x20;                           }

&#x20;                         },

&#x20;                         "style": {

&#x20;                           "textStyle": {

&#x20;                             "styleName": "label\_small"

&#x20;                           }

&#x20;                         },

&#x20;                         "color": {

&#x20;                           "color": {

&#x20;                             "color": "secondary\_text"

&#x20;                           }

&#x20;                         }

&#x20;                       },

&#x20;                       "editorId": "text66"

&#x20;                     }

&#x20;                   ],

&#x20;                   "editorId": "row46"

&#x20;                 }

&#x20;               ],

&#x20;               "editorId": "column52"

&#x20;             },

&#x20;             {

&#x20;               "type": "iconbutton",

&#x20;               "properties": {

&#x20;                 "name": {

&#x20;                   "icon": {

&#x20;                     "name": "settings\_rounded"

&#x20;                   }

&#x20;                 },

&#x20;                 "size": {

&#x20;                   "numberVal": {

&#x20;                     "value": 20

&#x20;                   }

&#x20;                 },

&#x20;                 "color": {

&#x20;                   "color": {

&#x20;                     "color": "secondary\_text"

&#x20;                   }

&#x20;                 }

&#x20;               },

&#x20;               "editorId": "iconbutton11"

&#x20;             }

&#x20;           ],

&#x20;           "editorId": "row45"

&#x20;         },

&#x20;         {

&#x20;           "type": "expanded",

&#x20;           "children": \[

&#x20;             {

&#x20;               "type": "center",

&#x20;               "children": \[

&#x20;                 {

&#x20;                   "type": "stack",

&#x20;                   "properties": {

&#x20;                     "align": {

&#x20;                       "align": {

&#x20;                         "named": "center"

&#x20;                       }

&#x20;                     }

&#x20;                   },

&#x20;                   "children": \[

&#x20;                     {

&#x20;                       "type": "progress",

&#x20;                       "properties": {

&#x20;                         "variant": {

&#x20;                           "stringVal": {

&#x20;                             "value": "circular"

&#x20;                           }

&#x20;                         },

&#x20;                         "value": {

&#x20;                           "numberVal": {

&#x20;                             "value": 0.75

&#x20;                           }

&#x20;                         },

&#x20;                         "size": {

&#x20;                           "numberVal": {

&#x20;                             "value": 280

&#x20;                           }

&#x20;                         },

&#x20;                         "thickness": {

&#x20;                           "numberVal": {

&#x20;                             "value": 12

&#x20;                           }

&#x20;                         },

&#x20;                         "color": {

&#x20;                           "color": {

&#x20;                             "color": "primary",

&#x20;                             "opacityPercent": 20

&#x20;                           }

&#x20;                         },

&#x20;                         "bg\_color": {

&#x20;                           "color": {

&#x20;                             "color": "divider"

&#x20;                           }

&#x20;                         }

&#x20;                       },

&#x20;                       "editorId": "progress5"

&#x20;                     },

&#x20;                     {

&#x20;                       "type": "progress",

&#x20;                       "properties": {

&#x20;                         "variant": {

&#x20;                           "stringVal": {

&#x20;                             "value": "circular"

&#x20;                           }

&#x20;                         },

&#x20;                         "value": {

&#x20;                           "numberVal": {

&#x20;                             "value": 0.45

&#x20;                           }

&#x20;                         },

&#x20;                         "size": {

&#x20;                           "numberVal": {

&#x20;                             "value": 280

&#x20;                           }

&#x20;                         },

&#x20;                         "thickness": {

&#x20;                           "numberVal": {

&#x20;                             "value": 12

&#x20;                           }

&#x20;                         },

&#x20;                         "color": {

&#x20;                           "color": {

&#x20;                             "color": "primary"

&#x20;                           }

&#x20;                         }

&#x20;                       },

&#x20;                       "editorId": "progress6"

&#x20;                     },

&#x20;                     {

&#x20;                       "type": "column",

&#x20;                       "properties": {

&#x20;                         "spacing": {

&#x20;                           "stringVal": {

&#x20;                             "value": "xs"

&#x20;                           }

&#x20;                         },

&#x20;                         "cross\_align": {

&#x20;                           "align": {

&#x20;                             "named": "center"

&#x20;                           }

&#x20;                         }

&#x20;                       },

&#x20;                       "children": \[

&#x20;                         {

&#x20;                           "type": "text",

&#x20;                           "properties": {

&#x20;                             "content": {

&#x20;                               "stringVal": {

&#x20;                                 "value": "27:14"

&#x20;                               }

&#x20;                             },

&#x20;                             "font\_size": {

&#x20;                               "numberVal": {

&#x20;                                 "value": 64

&#x20;                               }

&#x20;                             },

&#x20;                             "font\_weight": {

&#x20;                               "numberVal": {

&#x20;                                 "value": 200

&#x20;                               }

&#x20;                             },

&#x20;                             "color": {

&#x20;                               "color": {

&#x20;                                 "color": "primary\_text"

&#x20;                               }

&#x20;                             }

&#x20;                           },

&#x20;                           "editorId": "text67"

&#x20;                         },

&#x20;                         {

&#x20;                           "type": "text",

&#x20;                           "properties": {

&#x20;                             "content": {

&#x20;                               "stringVal": {

&#x20;                                 "value": "of 60:00"

&#x20;                               }

&#x20;                             },

&#x20;                             "style": {

&#x20;                               "textStyle": {

&#x20;                                 "styleName": "label\_large"

&#x20;                               }

&#x20;                             },

&#x20;                             "color": {

&#x20;                               "color": {

&#x20;                                 "color": "secondary\_text",

&#x20;                                 "opacityPercent": 60

&#x20;                               }

&#x20;                             }

&#x20;                           },

&#x20;                           "editorId": "text68"

&#x20;                         }

&#x20;                       ],

&#x20;                       "editorId": "column53"

&#x20;                     }

&#x20;                   ],

&#x20;                   "editorId": "stack5"

&#x20;                 }

&#x20;               ],

&#x20;               "editorId": "center2"

&#x20;             }

&#x20;           ],

&#x20;           "editorId": "expanded14"

&#x20;         },

&#x20;         {

&#x20;           "type": "container",

&#x20;           "properties": {

&#x20;             "bg": {

&#x20;               "color": {

&#x20;                 "color": "surface"

&#x20;               }

&#x20;             },

&#x20;             "radius": {

&#x20;               "radius": {

&#x20;                 "topLeft": 0,

&#x20;                 "topRight": 0,

&#x20;                 "bottomLeft": 0,

&#x20;                 "bottomRight": 0,

&#x20;                 "token": "xl"

&#x20;               }

&#x20;             },

&#x20;             "padding": {

&#x20;               "edgeInsets": {

&#x20;                 "top": 0,

&#x20;                 "right": 0,

&#x20;                 "bottom": 0,

&#x20;                 "left": 0,

&#x20;                 "token": "lg"

&#x20;               }

&#x20;             },

&#x20;             "shadow": {

&#x20;               "stringVal": {

&#x20;                 "value": "sm"

&#x20;               }

&#x20;             }

&#x20;           },

&#x20;           "children": \[

&#x20;             {

&#x20;               "type": "row",

&#x20;               "properties": {

&#x20;                 "align": {

&#x20;                   "align": {

&#x20;                     "named": "space\_around"

&#x20;                   }

&#x20;                 }

&#x20;               },

&#x20;               "children": \[

&#x20;                 {

&#x20;                   "type": "@session\_stat",

&#x20;                   "properties": {

&#x20;                     "label": {

&#x20;                       "stringVal": {

&#x20;                         "value": "Today"

&#x20;                       }

&#x20;                     },

&#x20;                     "value": {

&#x20;                       "stringVal": {

&#x20;                         "value": "45m"

&#x20;                       }

&#x20;                     }

&#x20;                   },

&#x20;                   "editorId": "sessionstat1"

&#x20;                 },

&#x20;                 {

&#x20;                   "type": "divider",

&#x20;                   "properties": {

&#x20;                     "vertical": {

&#x20;                       "boolVal": {

&#x20;                         "value": true

&#x20;                       }

&#x20;                     },

&#x20;                     "thickness": {

&#x20;                       "numberVal": {

&#x20;                         "value": 1

&#x20;                       }

&#x20;                     },

&#x20;                     "color": {

&#x20;                       "color": {

&#x20;                         "color": "divider"

&#x20;                       }

&#x20;                     },

&#x20;                     "height": {

&#x20;                       "px": {

&#x20;                         "value": 30,

&#x20;                         "isInfinity": false

&#x20;                       }

&#x20;                     }

&#x20;                   },

&#x20;                   "editorId": "divider2"

&#x20;                 },

&#x20;                 {

&#x20;                   "type": "@session\_stat",

&#x20;                   "properties": {

&#x20;                     "label": {

&#x20;                       "stringVal": {

&#x20;                         "value": "Weekly"

&#x20;                       }

&#x20;                     },

&#x20;                     "value": {

&#x20;                       "stringVal": {

&#x20;                         "value": "3.2h"

&#x20;                       }

&#x20;                     }

&#x20;                   },

&#x20;                   "editorId": "sessionstat2"

&#x20;                 },

&#x20;                 {

&#x20;                   "type": "divider",

&#x20;                   "properties": {

&#x20;                     "vertical": {

&#x20;                       "boolVal": {

&#x20;                         "value": true

&#x20;                       }

&#x20;                     },

&#x20;                     "thickness": {

&#x20;                       "numberVal": {

&#x20;                         "value": 1

&#x20;                       }

&#x20;                     },

&#x20;                     "color": {

&#x20;                       "color": {

&#x20;                         "color": "divider"

&#x20;                       }

&#x20;                     },

&#x20;                     "height": {

&#x20;                       "px": {

&#x20;                         "value": 30,

&#x20;                         "isInfinity": false

&#x20;                       }

&#x20;                     }

&#x20;                   },

&#x20;                   "editorId": "divider4"

&#x20;                 },

&#x20;                 {

&#x20;                   "type": "@session\_stat",

&#x20;                   "properties": {

&#x20;                     "label": {

&#x20;                       "stringVal": {

&#x20;                         "value": "Streak"

&#x20;                       }

&#x20;                     },

&#x20;                     "value": {

&#x20;                       "stringVal": {

&#x20;                         "value": "5d"

&#x20;                       }

&#x20;                     }

&#x20;                   },

&#x20;                   "editorId": "sessionstat3"

&#x20;                 }

&#x20;               ],

&#x20;               "editorId": "row47"

&#x20;             }

&#x20;           ],

&#x20;           "editorId": "container72"

&#x20;         },

&#x20;         {

&#x20;           "type": "column",

&#x20;           "properties": {

&#x20;             "spacing": {

&#x20;               "stringVal": {

&#x20;                 "value": "lg"

&#x20;               }

&#x20;             },

&#x20;             "cross\_align": {

&#x20;               "align": {

&#x20;                 "named": "center"

&#x20;               }

&#x20;             }

&#x20;           },

&#x20;           "children": \[

&#x20;             {

&#x20;               "type": "row",

&#x20;               "properties": {

&#x20;                 "spacing": {

&#x20;                   "stringVal": {

&#x20;                     "value": "xl"

&#x20;                   }

&#x20;                 },

&#x20;                 "align": {

&#x20;                   "align": {

&#x20;                     "named": "center"

&#x20;                   }

&#x20;                 }

&#x20;               },

&#x20;               "children": \[

&#x20;                 {

&#x20;                   "type": "iconbutton",

&#x20;                   "properties": {

&#x20;                     "name": {

&#x20;                       "icon": {

&#x20;                         "name": "stop\_rounded"

&#x20;                       }

&#x20;                     },

&#x20;                     "size": {

&#x20;                       "numberVal": {

&#x20;                         "value": 32

&#x20;                       }

&#x20;                     },

&#x20;                     "bg": {

&#x20;                       "color": {

&#x20;                         "color": "error",

&#x20;                         "opacityPercent": 10

&#x20;                       }

&#x20;                     },

&#x20;                     "color": {

&#x20;                       "color": {

&#x20;                         "color": "error"

&#x20;                       }

&#x20;                     },

&#x20;                     "radius": {

&#x20;                       "radius": {

&#x20;                         "topLeft": 0,

&#x20;                         "topRight": 0,

&#x20;                         "bottomLeft": 0,

&#x20;                         "bottomRight": 0,

&#x20;                         "token": "full"

&#x20;                       }

&#x20;                     },

&#x20;                     "padding": {

&#x20;                       "edgeInsets": {

&#x20;                         "top": 0,

&#x20;                         "right": 0,

&#x20;                         "bottom": 0,

&#x20;                         "left": 0,

&#x20;                         "token": "lg"

&#x20;                       }

&#x20;                     }

&#x20;                   },

&#x20;                   "editorId": "iconbutton12"

&#x20;                 },

&#x20;                 {

&#x20;                   "type": "container",

&#x20;                   "properties": {

&#x20;                     "width": {

&#x20;                       "px": {

&#x20;                         "value": 80,

&#x20;                         "isInfinity": false

&#x20;                       }

&#x20;                     },

&#x20;                     "height": {

&#x20;                       "px": {

&#x20;                         "value": 80,

&#x20;                         "isInfinity": false

&#x20;                       }

&#x20;                     },

&#x20;                     "bg": {

&#x20;                       "color": {

&#x20;                         "color": "primary"

&#x20;                       }

&#x20;                     },

&#x20;                     "radius": {

&#x20;                       "radius": {

&#x20;                         "topLeft": 0,

&#x20;                         "topRight": 0,

&#x20;                         "bottomLeft": 0,

&#x20;                         "bottomRight": 0,

&#x20;                         "token": "full"

&#x20;                       }

&#x20;                     },

&#x20;                     "shadow": {

&#x20;                       "stringVal": {

&#x20;                         "value": "md"

&#x20;                       }

&#x20;                     },

&#x20;                     "align\_child": {

&#x20;                       "align": {

&#x20;                         "named": "center"

&#x20;                       }

&#x20;                     }

&#x20;                   },

&#x20;                   "children": \[

&#x20;                     {

&#x20;                       "type": "icon",

&#x20;                       "properties": {

&#x20;                         "name": {

&#x20;                           "icon": {

&#x20;                             "name": "pause\_rounded"

&#x20;                           }

&#x20;                         },

&#x20;                         "size": {

&#x20;                           "numberVal": {

&#x20;                             "value": 40

&#x20;                           }

&#x20;                         },

&#x20;                         "color": {

&#x20;                           "color": {

&#x20;                             "color": "on\_primary"

&#x20;                           }

&#x20;                         }

&#x20;                       },

&#x20;                       "editorId": "icon25"

&#x20;                     }

&#x20;                   ],

&#x20;                   "editorId": "container73"

&#x20;                 },

&#x20;                 {

&#x20;                   "type": "iconbutton",

&#x20;                   "properties": {

&#x20;                     "name": {

&#x20;                       "icon": {

&#x20;                         "name": "skip\_next\_rounded"

&#x20;                       }

&#x20;                     },

&#x20;                     "size": {

&#x20;                       "numberVal": {

&#x20;                         "value": 32

&#x20;                       }

&#x20;                     },

&#x20;                     "bg": {

&#x20;                       "color": {

&#x20;                         "color": "secondary",

&#x20;                         "opacityPercent": 10

&#x20;                       }

&#x20;                     },

&#x20;                     "color": {

&#x20;                       "color": {

&#x20;                         "color": "secondary\_text"

&#x20;                       }

&#x20;                     },

&#x20;                     "radius": {

&#x20;                       "radius": {

&#x20;                         "topLeft": 0,

&#x20;                         "topRight": 0,

&#x20;                         "bottomLeft": 0,

&#x20;                         "bottomRight": 0,

&#x20;                         "token": "full"

&#x20;                       }

&#x20;                     },

&#x20;                     "padding": {

&#x20;                       "edgeInsets": {

&#x20;                         "top": 0,

&#x20;                         "right": 0,

&#x20;                         "bottom": 0,

&#x20;                         "left": 0,

&#x20;                         "token": "lg"

&#x20;                       }

&#x20;                     }

&#x20;                   },

&#x20;                   "editorId": "iconbutton13"

&#x20;                 }

&#x20;               ],

&#x20;               "editorId": "row48"

&#x20;             },

&#x20;             {

&#x20;               "type": "container",

&#x20;               "properties": {

&#x20;                 "bg": {

&#x20;                   "color": {

&#x20;                     "color": "surface"

&#x20;                   }

&#x20;                 },

&#x20;                 "radius": {

&#x20;                   "radius": {

&#x20;                     "topLeft": 0,

&#x20;                     "topRight": 0,

&#x20;                     "bottomLeft": 0,

&#x20;                     "bottomRight": 0,

&#x20;                     "token": "lg"

&#x20;                   }

&#x20;                 },

&#x20;                 "padding": {

&#x20;                   "edgeInsets": {

&#x20;                     "top": 0,

&#x20;                     "right": 0,

&#x20;                     "bottom": 0,

&#x20;                     "left": 0,

&#x20;                     "topToken": "md",

&#x20;                     "rightToken": "lg",

&#x20;                     "bottomToken": "md",

&#x20;                     "leftToken": "lg"

&#x20;                   }

&#x20;                 },

&#x20;                 "border": {

&#x20;                   "border": {

&#x20;                     "width": 1,

&#x20;                     "color": "divider"

&#x20;                   }

&#x20;                 }

&#x20;               },

&#x20;               "children": \[

&#x20;                 {

&#x20;                   "type": "row",

&#x20;                   "properties": {

&#x20;                     "spacing": {

&#x20;                       "stringVal": {

&#x20;                         "value": "md"

&#x20;                       }

&#x20;                     },

&#x20;                     "cross\_align": {

&#x20;                       "align": {

&#x20;                         "named": "center"

&#x20;                       }

&#x20;                     }

&#x20;                   },

&#x20;                   "children": \[

&#x20;                     {

&#x20;                       "type": "icon",

&#x20;                       "properties": {

&#x20;                         "name": {

&#x20;                           "icon": {

&#x20;                             "name": "sticky\_note\_2\_rounded"

&#x20;                           }

&#x20;                         },

&#x20;                         "color": {

&#x20;                           "color": {

&#x20;                             "color": "primary"

&#x20;                           }

&#x20;                         },

&#x20;                         "size": {

&#x20;                           "numberVal": {

&#x20;                             "value": 20

&#x20;                           }

&#x20;                         }

&#x20;                       },

&#x20;                       "editorId": "icon26"

&#x20;                     },

&#x20;                     {

&#x20;                       "type": "expanded",

&#x20;                       "children": \[

&#x20;                         {

&#x20;                           "type": "text",

&#x20;                           "properties": {

&#x20;                             "content": {

&#x20;                               "stringVal": {

&#x20;                                 "value": "Focus on the UI design system for Life Tracker..."

&#x20;                               }

&#x20;                             },

&#x20;                             "style": {

&#x20;                               "textStyle": {

&#x20;                                 "styleName": "body\_medium"

&#x20;                               }

&#x20;                             },

&#x20;                             "color": {

&#x20;                               "color": {

&#x20;                                 "color": "primary\_text"

&#x20;                               }

&#x20;                             },

&#x20;                             "max\_lines": {

&#x20;                               "numberVal": {

&#x20;                                 "value": 1

&#x20;                               }

&#x20;                             },

&#x20;                             "overflow": {

&#x20;                               "stringVal": {

&#x20;                                 "value": "ellipsis"

&#x20;                               }

&#x20;                             }

&#x20;                           },

&#x20;                           "editorId": "text69"

&#x20;                         }

&#x20;                       ],

&#x20;                       "editorId": "expanded15"

&#x20;                     },

&#x20;                     {

&#x20;                       "type": "iconbutton",

&#x20;                       "properties": {

&#x20;                         "name": {

&#x20;                           "icon": {

&#x20;                             "name": "edit\_rounded"

&#x20;                           }

&#x20;                         },

&#x20;                         "size": {

&#x20;                           "numberVal": {

&#x20;                             "value": 18

&#x20;                           }

&#x20;                         },

&#x20;                         "color": {

&#x20;                           "color": {

&#x20;                             "color": "secondary\_text"

&#x20;                           }

&#x20;                         }

&#x20;                       },

&#x20;                       "editorId": "iconbutton14"

&#x20;                     }

&#x20;                   ],

&#x20;                   "editorId": "row49"

&#x20;                 }

&#x20;               ],

&#x20;               "editorId": "container74"

&#x20;             }

&#x20;           ],

&#x20;           "editorId": "column54"

&#x20;         },

&#x20;         {

&#x20;           "type": "spacer",

&#x20;           "editorId": "spacer1"

&#x20;         },

&#x20;         {

&#x20;           "type": "@std.button",

&#x20;           "properties": {

&#x20;             "content": {

&#x20;               "stringVal": {

&#x20;                 "value": "Finish Session Early"

&#x20;               }

&#x20;             },

&#x20;             "variant": {

&#x20;               "stringVal": {

&#x20;                 "value": "ghost"

&#x20;               }

&#x20;             },

&#x20;             "full\_width": {

&#x20;               "boolVal": {

&#x20;                 "value": true

&#x20;               }

&#x20;             },

&#x20;             "icon": {

&#x20;               "stringVal": {

&#x20;                 "value": "check\_circle\_outline\_rounded"

&#x20;               }

&#x20;             }

&#x20;           },

&#x20;           "editorId": "stdbutton5"

&#x20;         }

&#x20;       ],

&#x20;       "editorId": "column51"

&#x20;     }

&#x20;   ],

&#x20;   "editorId": "scaffold5"

&#x20; }

}

```



\### 6. Categories Management



\- Frame ID: `frame5`

\- Original page prompt: "Grid view of all tracker categories with counts and options to add or edit category labels and colors."

\- Follow-up prompts: \_None\_



\#### DslDocument (JSON)



```json

{

&#x20; "root": {

&#x20;   "type": "scaffold",

&#x20;   "properties": {

&#x20;     "bg": {

&#x20;       "color": {

&#x20;         "color": "background"

&#x20;       }

&#x20;     }

&#x20;   },

&#x20;   "children": \[

&#x20;     {

&#x20;       "type": "column",

&#x20;       "properties": {

&#x20;         "cross\_align": {

&#x20;           "align": {

&#x20;             "named": "stretch"

&#x20;           }

&#x20;         }

&#x20;       },

&#x20;       "children": \[

&#x20;         {

&#x20;           "type": "container",

&#x20;           "properties": {

&#x20;             "padding": {

&#x20;               "edgeInsets": {

&#x20;                 "top": 24,

&#x20;                 "right": 24,

&#x20;                 "bottom": 16,

&#x20;                 "left": 24

&#x20;               }

&#x20;             }

&#x20;           },

&#x20;           "children": \[

&#x20;             {

&#x20;               "type": "row",

&#x20;               "properties": {

&#x20;                 "align": {

&#x20;                   "align": {

&#x20;                     "named": "space\_between"

&#x20;                   }

&#x20;                 },

&#x20;                 "cross\_align": {

&#x20;                   "align": {

&#x20;                     "named": "center"

&#x20;                   }

&#x20;                 }

&#x20;               },

&#x20;               "children": \[

&#x20;                 {

&#x20;                   "type": "column",

&#x20;                   "properties": {

&#x20;                     "cross\_align": {

&#x20;                       "align": {

&#x20;                         "named": "start"

&#x20;                       }

&#x20;                     },

&#x20;                     "spacing": {

&#x20;                       "stringVal": {

&#x20;                         "value": "xs"

&#x20;                       }

&#x20;                     }

&#x20;                   },

&#x20;                   "children": \[

&#x20;                     {

&#x20;                       "type": "text",

&#x20;                       "properties": {

&#x20;                         "content": {

&#x20;                           "stringVal": {

&#x20;                             "value": "Categories"

&#x20;                           }

&#x20;                         },

&#x20;                         "style": {

&#x20;                           "textStyle": {

&#x20;                             "styleName": "headline\_medium"

&#x20;                           }

&#x20;                         },

&#x20;                         "font\_weight": {

&#x20;                           "stringVal": {

&#x20;                             "value": "bold"

&#x20;                           }

&#x20;                         },

&#x20;                         "color": {

&#x20;                           "color": {

&#x20;                             "color": "primary\_text"

&#x20;                           }

&#x20;                         }

&#x20;                       },

&#x20;                       "editorId": "text80"

&#x20;                     },

&#x20;                     {

&#x20;                       "type": "text",

&#x20;                       "properties": {

&#x20;                         "content": {

&#x20;                           "stringVal": {

&#x20;                             "value": "Organize your trackers"

&#x20;                           }

&#x20;                         },

&#x20;                         "style": {

&#x20;                           "textStyle": {

&#x20;                             "styleName": "body\_small"

&#x20;                           }

&#x20;                         },

&#x20;                         "color": {

&#x20;                           "color": {

&#x20;                             "color": "secondary\_text"

&#x20;                           }

&#x20;                         }

&#x20;                       },

&#x20;                       "editorId": "text70"

&#x20;                     }

&#x20;                   ],

&#x20;                   "editorId": "column56"

&#x20;                 },

&#x20;                 {

&#x20;                   "type": "container",

&#x20;                   "properties": {

&#x20;                     "width": {

&#x20;                       "px": {

&#x20;                         "value": 44,

&#x20;                         "isInfinity": false

&#x20;                       }

&#x20;                     },

&#x20;                     "height": {

&#x20;                       "px": {

&#x20;                         "value": 44,

&#x20;                         "isInfinity": false

&#x20;                       }

&#x20;                     },

&#x20;                     "bg": {

&#x20;                       "color": {

&#x20;                         "color": "primary"

&#x20;                       }

&#x20;                     },

&#x20;                     "radius": {

&#x20;                       "radius": {

&#x20;                         "topLeft": 0,

&#x20;                         "topRight": 0,

&#x20;                         "bottomLeft": 0,

&#x20;                         "bottomRight": 0,

&#x20;                         "token": "full"

&#x20;                       }

&#x20;                     },

&#x20;                     "align\_child": {

&#x20;                       "align": {

&#x20;                         "named": "center"

&#x20;                       }

&#x20;                     },

&#x20;                     "on\_tap": {

&#x20;                       "stringVal": {

&#x20;                         "value": "navigate:AddOrEditTracker"

&#x20;                       }

&#x20;                     }

&#x20;                   },

&#x20;                   "children": \[

&#x20;                     {

&#x20;                       "type": "icon",

&#x20;                       "properties": {

&#x20;                         "name": {

&#x20;                           "icon": {

&#x20;                             "name": "add\_rounded"

&#x20;                           }

&#x20;                         },

&#x20;                         "color": {

&#x20;                           "color": {

&#x20;                             "color": "on\_primary"

&#x20;                           }

&#x20;                         },

&#x20;                         "size": {

&#x20;                           "numberVal": {

&#x20;                             "value": 24

&#x20;                           }

&#x20;                         }

&#x20;                       },

&#x20;                       "editorId": "icon27"

&#x20;                     }

&#x20;                   ],

&#x20;                   "editorId": "container76"

&#x20;                 }

&#x20;               ],

&#x20;               "editorId": "row50"

&#x20;             }

&#x20;           ],

&#x20;           "editorId": "container75"

&#x20;         },

&#x20;         {

&#x20;           "type": "expanded",

&#x20;           "children": \[

&#x20;             {

&#x20;               "type": "column",

&#x20;               "properties": {

&#x20;                 "scroll": {

&#x20;                   "boolVal": {

&#x20;                     "value": true

&#x20;                   }

&#x20;                 },

&#x20;                 "padding": {

&#x20;                   "edgeInsets": {

&#x20;                     "top": 0,

&#x20;                     "right": 24,

&#x20;                     "bottom": 100,

&#x20;                     "left": 24

&#x20;                   }

&#x20;                 },

&#x20;                 "spacing": {

&#x20;                   "stringVal": {

&#x20;                     "value": "lg"

&#x20;                   }

&#x20;                 }

&#x20;               },

&#x20;               "children": \[

&#x20;                 {

&#x20;                   "type": "row",

&#x20;                   "properties": {

&#x20;                     "spacing": {

&#x20;                       "stringVal": {

&#x20;                         "value": "md"

&#x20;                       }

&#x20;                     }

&#x20;                   },

&#x20;                   "children": \[

&#x20;                     {

&#x20;                       "type": "container",

&#x20;                       "properties": {

&#x20;                         "expanded": {

&#x20;                           "expanded": {

&#x20;                             "enabled": true,

&#x20;                             "flex": 1

&#x20;                           }

&#x20;                         },

&#x20;                         "bg": {

&#x20;                           "color": {

&#x20;                             "color": "surface"

&#x20;                           }

&#x20;                         },

&#x20;                         "padding": {

&#x20;                           "edgeInsets": {

&#x20;                             "top": 0,

&#x20;                             "right": 0,

&#x20;                             "bottom": 0,

&#x20;                             "left": 0,

&#x20;                             "token": "md"

&#x20;                           }

&#x20;                         },

&#x20;                         "radius": {

&#x20;                           "radius": {

&#x20;                             "topLeft": 0,

&#x20;                             "topRight": 0,

&#x20;                             "bottomLeft": 0,

&#x20;                             "bottomRight": 0,

&#x20;                             "token": "lg"

&#x20;                           }

&#x20;                         },

&#x20;                         "border": {

&#x20;                           "border": {

&#x20;                             "width": 1,

&#x20;                             "color": "divider"

&#x20;                           }

&#x20;                         }

&#x20;                       },

&#x20;                       "children": \[

&#x20;                         {

&#x20;                           "type": "column",

&#x20;                           "properties": {

&#x20;                             "spacing": {

&#x20;                               "stringVal": {

&#x20;                                 "value": "xs"

&#x20;                               }

&#x20;                             }

&#x20;                           },

&#x20;                           "children": \[

&#x20;                             {

&#x20;                               "type": "text",

&#x20;                               "properties": {

&#x20;                                 "content": {

&#x20;                                   "stringVal": {

&#x20;                                     "value": "Total"

&#x20;                                   }

&#x20;                                 },

&#x20;                                 "style": {

&#x20;                                   "textStyle": {

&#x20;                                     "styleName": "label\_small"

&#x20;                                   }

&#x20;                                 },

&#x20;                                 "color": {

&#x20;                                   "color": {

&#x20;                                     "color": "secondary\_text"

&#x20;                                   }

&#x20;                                 }

&#x20;                               },

&#x20;                               "editorId": "text81"

&#x20;                             },

&#x20;                             {

&#x20;                               "type": "text",

&#x20;                               "properties": {

&#x20;                                 "content": {

&#x20;                                   "stringVal": {

&#x20;                                     "value": "6"

&#x20;                                   }

&#x20;                                 },

&#x20;                                 "style": {

&#x20;                                   "textStyle": {

&#x20;                                     "styleName": "title\_large"

&#x20;                                   }

&#x20;                                 },

&#x20;                                 "font\_weight": {

&#x20;                                   "stringVal": {

&#x20;                                     "value": "bold"

&#x20;                                   }

&#x20;                                 },

&#x20;                                 "color": {

&#x20;                                   "color": {

&#x20;                                     "color": "primary\_text"

&#x20;                                   }

&#x20;                                 }

&#x20;                               },

&#x20;                               "editorId": "text82"

&#x20;                             }

&#x20;                           ],

&#x20;                           "editorId": "column58"

&#x20;                         }

&#x20;                       ],

&#x20;                       "editorId": "container77"

&#x20;                     },

&#x20;                     {

&#x20;                       "type": "container",

&#x20;                       "properties": {

&#x20;                         "expanded": {

&#x20;                           "expanded": {

&#x20;                             "enabled": true,

&#x20;                             "flex": 1

&#x20;                           }

&#x20;                         },

&#x20;                         "bg": {

&#x20;                           "color": {

&#x20;                             "color": "surface"

&#x20;                           }

&#x20;                         },

&#x20;                         "padding": {

&#x20;                           "edgeInsets": {

&#x20;                             "top": 0,

&#x20;                             "right": 0,

&#x20;                             "bottom": 0,

&#x20;                             "left": 0,

&#x20;                             "token": "md"

&#x20;                           }

&#x20;                         },

&#x20;                         "radius": {

&#x20;                           "radius": {

&#x20;                             "topLeft": 0,

&#x20;                             "topRight": 0,

&#x20;                             "bottomLeft": 0,

&#x20;                             "bottomRight": 0,

&#x20;                             "token": "lg"

&#x20;                           }

&#x20;                         },

&#x20;                         "border": {

&#x20;                           "border": {

&#x20;                             "width": 1,

&#x20;                             "color": "divider"

&#x20;                           }

&#x20;                         }

&#x20;                       },

&#x20;                       "children": \[

&#x20;                         {

&#x20;                           "type": "column",

&#x20;                           "properties": {

&#x20;                             "spacing": {

&#x20;                               "stringVal": {

&#x20;                                 "value": "xs"

&#x20;                               }

&#x20;                             }

&#x20;                           },

&#x20;                           "children": \[

&#x20;                             {

&#x20;                               "type": "text",

&#x20;                               "properties": {

&#x20;                                 "content": {

&#x20;                                   "stringVal": {

&#x20;                                     "value": "Active"

&#x20;                                   }

&#x20;                                 },

&#x20;                                 "style": {

&#x20;                                   "textStyle": {

&#x20;                                     "styleName": "label\_small"

&#x20;                                   }

&#x20;                                 },

&#x20;                                 "color": {

&#x20;                                   "color": {

&#x20;                                     "color": "secondary\_text"

&#x20;                                   }

&#x20;                                 }

&#x20;                               },

&#x20;                               "editorId": "text83"

&#x20;                             },

&#x20;                             {

&#x20;                               "type": "text",

&#x20;                               "properties": {

&#x20;                                 "content": {

&#x20;                                   "stringVal": {

&#x20;                                     "value": "24"

&#x20;                                   }

&#x20;                                 },

&#x20;                                 "style": {

&#x20;                                   "textStyle": {

&#x20;                                     "styleName": "title\_large"

&#x20;                                   }

&#x20;                                 },

&#x20;                                 "font\_weight": {

&#x20;                                   "stringVal": {

&#x20;                                     "value": "bold"

&#x20;                                   }

&#x20;                                 },

&#x20;                                 "color": {

&#x20;                                   "color": {

&#x20;                                     "color": "primary\_text"

&#x20;                                   }

&#x20;                                 }

&#x20;                               },

&#x20;                               "editorId": "text84"

&#x20;                             }

&#x20;                           ],

&#x20;                           "editorId": "column59"

&#x20;                         }

&#x20;                       ],

&#x20;                       "editorId": "container78"

&#x20;                     }

&#x20;                   ],

&#x20;                   "editorId": "row51"

&#x20;                 },

&#x20;                 {

&#x20;                   "type": "grid",

&#x20;                   "properties": {

&#x20;                     "columns": {

&#x20;                       "numberVal": {

&#x20;                         "value": 2

&#x20;                       }

&#x20;                     },

&#x20;                     "spacing": {

&#x20;                       "stringVal": {

&#x20;                         "value": "md"

&#x20;                       }

&#x20;                     },

&#x20;                     "run\_spacing": {

&#x20;                       "stringVal": {

&#x20;                         "value": "md"

&#x20;                       }

&#x20;                     },

&#x20;                     "shrink\_wrap": {

&#x20;                       "boolVal": {

&#x20;                         "value": true

&#x20;                       }

&#x20;                     }

&#x20;                   },

&#x20;                   "children": \[

&#x20;                     {

&#x20;                       "type": "@category\_card",

&#x20;                       "properties": {

&#x20;                         "name": {

&#x20;                           "stringVal": {

&#x20;                             "value": "Health"

&#x20;                           }

&#x20;                         },

&#x20;                         "icon": {

&#x20;                           "stringVal": {

&#x20;                             "value": "favorite\_rounded"

&#x20;                           }

&#x20;                         },

&#x20;                         "color": {

&#x20;                           "stringVal": {

&#x20;                             "value": "error"

&#x20;                           }

&#x20;                         },

&#x20;                         "count": {

&#x20;                           "stringVal": {

&#x20;                             "value": "8"

&#x20;                           }

&#x20;                         }

&#x20;                       },

&#x20;                       "editorId": "categorycard1"

&#x20;                     },

&#x20;                     {

&#x20;                       "type": "@category\_card",

&#x20;                       "properties": {

&#x20;                         "name": {

&#x20;                           "stringVal": {

&#x20;                             "value": "Productivity"

&#x20;                           }

&#x20;                         },

&#x20;                         "icon": {

&#x20;                           "stringVal": {

&#x20;                             "value": "lightbulb\_rounded"

&#x20;                           }

&#x20;                         },

&#x20;                         "color": {

&#x20;                           "stringVal": {

&#x20;                             "value": "accent"

&#x20;                           }

&#x20;                         },

&#x20;                         "count": {

&#x20;                           "stringVal": {

&#x20;                             "value": "5"

&#x20;                           }

&#x20;                         }

&#x20;                       },

&#x20;                       "editorId": "categorycard2"

&#x20;                     },

&#x20;                     {

&#x20;                       "type": "@category\_card",

&#x20;                       "properties": {

&#x20;                         "name": {

&#x20;                           "stringVal": {

&#x20;                             "value": "Mindfulness"

&#x20;                           }

&#x20;                         },

&#x20;                         "icon": {

&#x20;                           "stringVal": {

&#x20;                             "value": "self\_improvement\_rounded"

&#x20;                           }

&#x20;                         },

&#x20;                         "color": {

&#x20;                           "stringVal": {

&#x20;                             "value": "primary"

&#x20;                           }

&#x20;                         },

&#x20;                         "count": {

&#x20;                           "stringVal": {

&#x20;                             "value": "4"

&#x20;                           }

&#x20;                         }

&#x20;                       },

&#x20;                       "editorId": "categorycard3"

&#x20;                     },

&#x20;                     {

&#x20;                       "type": "@category\_card",

&#x20;                       "properties": {

&#x20;                         "name": {

&#x20;                           "stringVal": {

&#x20;                             "value": "Fitness"

&#x20;                           }

&#x20;                         },

&#x20;                         "icon": {

&#x20;                           "stringVal": {

&#x20;                             "value": "fitness\_center\_rounded"

&#x20;                           }

&#x20;                         },

&#x20;                         "color": {

&#x20;                           "stringVal": {

&#x20;                             "value": "success"

&#x20;                           }

&#x20;                         },

&#x20;                         "count": {

&#x20;                           "stringVal": {

&#x20;                             "value": "3"

&#x20;                           }

&#x20;                         }

&#x20;                       },

&#x20;                       "editorId": "categorycard4"

&#x20;                     },

&#x20;                     {

&#x20;                       "type": "@category\_card",

&#x20;                       "properties": {

&#x20;                         "name": {

&#x20;                           "stringVal": {

&#x20;                             "value": "Nutrition"

&#x20;                           }

&#x20;                         },

&#x20;                         "icon": {

&#x20;                           "stringVal": {

&#x20;                             "value": "restaurant\_rounded"

&#x20;                           }

&#x20;                         },

&#x20;                         "color": {

&#x20;                           "stringVal": {

&#x20;                             "value": "warning"

&#x20;                           }

&#x20;                         },

&#x20;                         "count": {

&#x20;                           "stringVal": {

&#x20;                             "value": "2"

&#x20;                           }

&#x20;                         }

&#x20;                       },

&#x20;                       "editorId": "categorycard5"

&#x20;                     },

&#x20;                     {

&#x20;                       "type": "@category\_card",

&#x20;                       "properties": {

&#x20;                         "name": {

&#x20;                           "stringVal": {

&#x20;                             "value": "Finance"

&#x20;                           }

&#x20;                         },

&#x20;                         "icon": {

&#x20;                           "stringVal": {

&#x20;                             "value": "payments\_rounded"

&#x20;                           }

&#x20;                         },

&#x20;                         "color": {

&#x20;                           "stringVal": {

&#x20;                             "value": "info"

&#x20;                           }

&#x20;                         },

&#x20;                         "count": {

&#x20;                           "stringVal": {

&#x20;                             "value": "2"

&#x20;                           }

&#x20;                         }

&#x20;                       },

&#x20;                       "editorId": "categorycard6"

&#x20;                     }

&#x20;                   ],

&#x20;                   "editorId": "grid2"

&#x20;                 },

&#x20;                 {

&#x20;                   "type": "container",

&#x20;                   "properties": {

&#x20;                     "padding": {

&#x20;                       "edgeInsets": {

&#x20;                         "top": 0,

&#x20;                         "right": 0,

&#x20;                         "bottom": 0,

&#x20;                         "left": 0,

&#x20;                         "token": "lg"

&#x20;                       }

&#x20;                     },

&#x20;                     "radius": {

&#x20;                       "radius": {

&#x20;                         "topLeft": 0,

&#x20;                         "topRight": 0,

&#x20;                         "bottomLeft": 0,

&#x20;                         "bottomRight": 0,

&#x20;                         "token": "lg"

&#x20;                       }

&#x20;                     },

&#x20;                     "border": {

&#x20;                       "border": {

&#x20;                         "width": 1,

&#x20;                         "color": "divider"

&#x20;                       }

&#x20;                     },

&#x20;                     "bg": {

&#x20;                       "color": {

&#x20;                         "color": "surface",

&#x20;                         "opacityPercent": 50

&#x20;                       }

&#x20;                     }

&#x20;                   },

&#x20;                   "children": \[

&#x20;                     {

&#x20;                       "type": "row",

&#x20;                       "properties": {

&#x20;                         "spacing": {

&#x20;                           "stringVal": {

&#x20;                             "value": "md"

&#x20;                           }

&#x20;                         },

&#x20;                         "cross\_align": {

&#x20;                           "align": {

&#x20;                             "named": "center"

&#x20;                           }

&#x20;                         }

&#x20;                       },

&#x20;                       "children": \[

&#x20;                         {

&#x20;                           "type": "icon",

&#x20;                           "properties": {

&#x20;                             "name": {

&#x20;                               "icon": {

&#x20;                                 "name": "info\_outline\_rounded"

&#x20;                               }

&#x20;                             },

&#x20;                             "color": {

&#x20;                               "color": {

&#x20;                                 "color": "secondary\_text"

&#x20;                               }

&#x20;                             },

&#x20;                             "size": {

&#x20;                               "numberVal": {

&#x20;                                 "value": 20

&#x20;                               }

&#x20;                             }

&#x20;                           },

&#x20;                           "editorId": "icon28"

&#x20;                         },

&#x20;                         {

&#x20;                           "type": "expanded",

&#x20;                           "children": \[

&#x20;                             {

&#x20;                               "type": "text",

&#x20;                               "properties": {

&#x20;                                 "content": {

&#x20;                                   "stringVal": {

&#x20;                                     "value": "Tap a category to view its trackers, or edit to change icons and colors."

&#x20;                                   }

&#x20;                                 },

&#x20;                                 "style": {

&#x20;                                   "textStyle": {

&#x20;                                     "styleName": "body\_small"

&#x20;                                   }

&#x20;                                 },

&#x20;                                 "color": {

&#x20;                                   "color": {

&#x20;                                     "color": "secondary\_text"

&#x20;                                   }

&#x20;                                 },

&#x20;                                 "max\_lines": {

&#x20;                                   "numberVal": {

&#x20;                                     "value": 2

&#x20;                                   }

&#x20;                                 }

&#x20;                               },

&#x20;                               "editorId": "text85"

&#x20;                             }

&#x20;                           ],

&#x20;                           "editorId": "expanded17"

&#x20;                         }

&#x20;                       ],

&#x20;                       "editorId": "row52"

&#x20;                     }

&#x20;                   ],

&#x20;                   "editorId": "container79"

&#x20;                 }

&#x20;               ],

&#x20;               "editorId": "column57"

&#x20;             }

&#x20;           ],

&#x20;           "editorId": "expanded16"

&#x20;         },

&#x20;         {

&#x20;           "type": "stack",

&#x20;           "properties": {

&#x20;             "height": {

&#x20;               "px": {

&#x20;                 "value": 0,

&#x20;                 "isInfinity": false

&#x20;               }

&#x20;             }

&#x20;           },

&#x20;           "children": \[

&#x20;             {

&#x20;               "type": "container",

&#x20;               "properties": {

&#x20;                 "align": {

&#x20;                   "align": {

&#x20;                     "named": "bottom\_center"

&#x20;                   }

&#x20;                 },

&#x20;                 "height": {

&#x20;                   "px": {

&#x20;                     "value": 80,

&#x20;                     "isInfinity": false

&#x20;                   }

&#x20;                 },

&#x20;                 "bg": {

&#x20;                   "color": {

&#x20;                     "color": "surface"

&#x20;                   }

&#x20;                 },

&#x20;                 "border": {

&#x20;                   "borderSided": {

&#x20;                     "side": "top",

&#x20;                     "width": 1,

&#x20;                     "color": "divider"

&#x20;                   }

&#x20;                 },

&#x20;                 "padding": {

&#x20;                   "edgeInsets": {

&#x20;                     "top": 0,

&#x20;                     "right": 32,

&#x20;                     "bottom": 0,

&#x20;                     "left": 32

&#x20;                   }

&#x20;                 }

&#x20;               },

&#x20;               "children": \[

&#x20;                 {

&#x20;                   "type": "row",

&#x20;                   "properties": {

&#x20;                     "align": {

&#x20;                       "align": {

&#x20;                         "named": "space\_around"

&#x20;                       }

&#x20;                     },

&#x20;                     "cross\_align": {

&#x20;                       "align": {

&#x20;                         "named": "center"

&#x20;                       }

&#x20;                     }

&#x20;                   },

&#x20;                   "children": \[

&#x20;                     {

&#x20;                       "type": "column",

&#x20;                       "properties": {

&#x20;                         "spacing": {

&#x20;                           "stringVal": {

&#x20;                             "value": "xs"

&#x20;                           }

&#x20;                         },

&#x20;                         "on\_tap": {

&#x20;                           "stringVal": {

&#x20;                             "value": "navigate:Dashboard"

&#x20;                           }

&#x20;                         }

&#x20;                       },

&#x20;                       "children": \[

&#x20;                         {

&#x20;                           "type": "icon",

&#x20;                           "properties": {

&#x20;                             "name": {

&#x20;                               "icon": {

&#x20;                                 "name": "dashboard\_rounded"

&#x20;                               }

&#x20;                             },

&#x20;                             "color": {

&#x20;                               "color": {

&#x20;                                 "color": "secondary\_text"

&#x20;                               }

&#x20;                             }

&#x20;                           },

&#x20;                           "editorId": "icon29"

&#x20;                         },

&#x20;                         {

&#x20;                           "type": "text",

&#x20;                           "properties": {

&#x20;                             "content": {

&#x20;                               "stringVal": {

&#x20;                                 "value": "Home"

&#x20;                               }

&#x20;                             },

&#x20;                             "style": {

&#x20;                               "textStyle": {

&#x20;                                 "styleName": "label\_small"

&#x20;                               }

&#x20;                             },

&#x20;                             "color": {

&#x20;                               "color": {

&#x20;                                 "color": "secondary\_text"

&#x20;                               }

&#x20;                             }

&#x20;                           },

&#x20;                           "editorId": "text86"

&#x20;                         }

&#x20;                       ],

&#x20;                       "editorId": "column60"

&#x20;                     },

&#x20;                     {

&#x20;                       "type": "column",

&#x20;                       "properties": {

&#x20;                         "spacing": {

&#x20;                           "stringVal": {

&#x20;                             "value": "xs"

&#x20;                           }

&#x20;                         }

&#x20;                       },

&#x20;                       "children": \[

&#x20;                         {

&#x20;                           "type": "icon",

&#x20;                           "properties": {

&#x20;                             "name": {

&#x20;                               "icon": {

&#x20;                                 "name": "category\_rounded"

&#x20;                               }

&#x20;                             },

&#x20;                             "color": {

&#x20;                               "color": {

&#x20;                                 "color": "primary"

&#x20;                               }

&#x20;                             }

&#x20;                           },

&#x20;                           "editorId": "icon30"

&#x20;                         },

&#x20;                         {

&#x20;                           "type": "text",

&#x20;                           "properties": {

&#x20;                             "content": {

&#x20;                               "stringVal": {

&#x20;                                 "value": "Categories"

&#x20;                               }

&#x20;                             },

&#x20;                             "style": {

&#x20;                               "textStyle": {

&#x20;                                 "styleName": "label\_small"

&#x20;                               }

&#x20;                             },

&#x20;                             "color": {

&#x20;                               "color": {

&#x20;                                 "color": "primary"

&#x20;                               }

&#x20;                             }

&#x20;                           },

&#x20;                           "editorId": "text87"

&#x20;                         }

&#x20;                       ],

&#x20;                       "editorId": "column61"

&#x20;                     },

&#x20;                     {

&#x20;                       "type": "column",

&#x20;                       "properties": {

&#x20;                         "spacing": {

&#x20;                           "stringVal": {

&#x20;                             "value": "xs"

&#x20;                           }

&#x20;                         },

&#x20;                         "on\_tap": {

&#x20;                           "stringVal": {

&#x20;                             "value": "navigate:AnalyticsInsights"

&#x20;                           }

&#x20;                         }

&#x20;                       },

&#x20;                       "children": \[

&#x20;                         {

&#x20;                           "type": "icon",

&#x20;                           "properties": {

&#x20;                             "name": {

&#x20;                               "icon": {

&#x20;                                 "name": "insert\_chart\_rounded"

&#x20;                               }

&#x20;                             },

&#x20;                             "color": {

&#x20;                               "color": {

&#x20;                                 "color": "secondary\_text"

&#x20;                               }

&#x20;                             }

&#x20;                           },

&#x20;                           "editorId": "icon31"

&#x20;                         },

&#x20;                         {

&#x20;                           "type": "text",

&#x20;                           "properties": {

&#x20;                             "content": {

&#x20;                               "stringVal": {

&#x20;                                 "value": "Insights"

&#x20;                               }

&#x20;                             },

&#x20;                             "style": {

&#x20;                               "textStyle": {

&#x20;                                 "styleName": "label\_small"

&#x20;                               }

&#x20;                             },

&#x20;                             "color": {

&#x20;                               "color": {

&#x20;                                 "color": "secondary\_text"

&#x20;                               }

&#x20;                             }

&#x20;                           },

&#x20;                           "editorId": "text88"

&#x20;                         }

&#x20;                       ],

&#x20;                       "editorId": "column62"

&#x20;                     },

&#x20;                     {

&#x20;                       "type": "column",

&#x20;                       "properties": {

&#x20;                         "spacing": {

&#x20;                           "stringVal": {

&#x20;                             "value": "xs"

&#x20;                           }

&#x20;                         },

&#x20;                         "on\_tap": {

&#x20;                           "stringVal": {

&#x20;                             "value": "navigate:Settings"

&#x20;                           }

&#x20;                         }

&#x20;                       },

&#x20;                       "children": \[

&#x20;                         {

&#x20;                           "type": "icon",

&#x20;                           "properties": {

&#x20;                             "name": {

&#x20;                               "icon": {

&#x20;                                 "name": "settings\_rounded"

&#x20;                               }

&#x20;                             },

&#x20;                             "color": {

&#x20;                               "color": {

&#x20;                                 "color": "secondary\_text"

&#x20;                               }

&#x20;                             }

&#x20;                           },

&#x20;                           "editorId": "icon32"

&#x20;                         },

&#x20;                         {

&#x20;                           "type": "text",

&#x20;                           "properties": {

&#x20;                             "content": {

&#x20;                               "stringVal": {

&#x20;                                 "value": "Settings"

&#x20;                               }

&#x20;                             },

&#x20;                             "style": {

&#x20;                               "textStyle": {

&#x20;                                 "styleName": "label\_small"

&#x20;                               }

&#x20;                             },

&#x20;                             "color": {

&#x20;                               "color": {

&#x20;                                 "color": "secondary\_text"

&#x20;                               }

&#x20;                             }

&#x20;                           },

&#x20;                           "editorId": "text89"

&#x20;                         }

&#x20;                       ],

&#x20;                       "editorId": "column63"

&#x20;                     }

&#x20;                   ],

&#x20;                   "editorId": "row53"

&#x20;                 }

&#x20;               ],

&#x20;               "editorId": "container80"

&#x20;             }

&#x20;           ],

&#x20;           "editorId": "stack6"

&#x20;         }

&#x20;       ],

&#x20;       "editorId": "column55"

&#x20;     }

&#x20;   ],

&#x20;   "editorId": "scaffold6"

&#x20; }

}

```



\### 7. Analytics \& Insights



\- Frame ID: `frame6`

\- Original page prompt: "Comprehensive overview of performance with bar charts for category breakdowns and tracker comparison lines."

\- Follow-up prompts: \_None\_



\#### DslDocument (JSON)



```json

{

&#x20; "root": {

&#x20;   "type": "scaffold",

&#x20;   "properties": {

&#x20;     "bg": {

&#x20;       "color": {

&#x20;         "color": "background"

&#x20;       }

&#x20;     }

&#x20;   },

&#x20;   "children": \[

&#x20;     {

&#x20;       "type": "column",

&#x20;       "properties": {

&#x20;         "scroll": {

&#x20;           "boolVal": {

&#x20;             "value": true

&#x20;           }

&#x20;         },

&#x20;         "cross\_align": {

&#x20;           "align": {

&#x20;             "named": "stretch"

&#x20;           }

&#x20;         }

&#x20;       },

&#x20;       "children": \[

&#x20;         {

&#x20;           "type": "container",

&#x20;           "properties": {

&#x20;             "padding": {

&#x20;               "edgeInsets": {

&#x20;                 "top": 0,

&#x20;                 "right": 0,

&#x20;                 "bottom": 0,

&#x20;                 "left": 0,

&#x20;                 "token": "lg"

&#x20;               }

&#x20;             },

&#x20;             "bg": {

&#x20;               "color": {

&#x20;                 "color": "surface"

&#x20;               }

&#x20;             },

&#x20;             "border": {

&#x20;               "borderSided": {

&#x20;                 "side": "bottom",

&#x20;                 "width": 1,

&#x20;                 "color": "divider"

&#x20;               }

&#x20;             }

&#x20;           },

&#x20;           "children": \[

&#x20;             {

&#x20;               "type": "column",

&#x20;               "properties": {

&#x20;                 "spacing": {

&#x20;                   "stringVal": {

&#x20;                     "value": "xs"

&#x20;                   }

&#x20;                 },

&#x20;                 "cross\_align": {

&#x20;                   "align": {

&#x20;                     "named": "start"

&#x20;                   }

&#x20;                 }

&#x20;               },

&#x20;               "children": \[

&#x20;                 {

&#x20;                   "type": "text",

&#x20;                   "properties": {

&#x20;                     "content": {

&#x20;                       "stringVal": {

&#x20;                         "value": "Analytics \& Insights"

&#x20;                       }

&#x20;                     },

&#x20;                     "style": {

&#x20;                       "textStyle": {

&#x20;                         "styleName": "headline\_medium"

&#x20;                       }

&#x20;                     },

&#x20;                     "font\_weight": {

&#x20;                       "stringVal": {

&#x20;                         "value": "bold"

&#x20;                       }

&#x20;                     },

&#x20;                     "color": {

&#x20;                       "color": {

&#x20;                         "color": "primary\_text"

&#x20;                       }

&#x20;                     }

&#x20;                   },

&#x20;                   "editorId": "text90"

&#x20;                 },

&#x20;                 {

&#x20;                   "type": "text",

&#x20;                   "properties": {

&#x20;                     "content": {

&#x20;                       "stringVal": {

&#x20;                         "value": "Your performance over the last 30 days"

&#x20;                       }

&#x20;                     },

&#x20;                     "style": {

&#x20;                       "textStyle": {

&#x20;                         "styleName": "body\_small"

&#x20;                       }

&#x20;                     },

&#x20;                     "color": {

&#x20;                       "color": {

&#x20;                         "color": "secondary\_text"

&#x20;                       }

&#x20;                     }

&#x20;                   },

&#x20;                   "editorId": "text91"

&#x20;                 }

&#x20;               ],

&#x20;               "editorId": "column65"

&#x20;             }

&#x20;           ],

&#x20;           "editorId": "container81"

&#x20;         },

&#x20;         {

&#x20;           "type": "container",

&#x20;           "properties": {

&#x20;             "padding": {

&#x20;               "edgeInsets": {

&#x20;                 "top": 0,

&#x20;                 "right": 0,

&#x20;                 "bottom": 0,

&#x20;                 "left": 0,

&#x20;                 "topToken": "lg",

&#x20;                 "rightToken": "md",

&#x20;                 "bottomToken": "lg",

&#x20;                 "leftToken": "md"

&#x20;               }

&#x20;             },

&#x20;             "bg": {

&#x20;               "color": {

&#x20;                 "color": "surface"

&#x20;               }

&#x20;             }

&#x20;           },

&#x20;           "children": \[

&#x20;             {

&#x20;               "type": "@std.tab\_group",

&#x20;               "properties": {

&#x20;                 "label\_1": {

&#x20;                   "stringVal": {

&#x20;                     "value": "Week"

&#x20;                   }

&#x20;                 },

&#x20;                 "label\_2": {

&#x20;                   "stringVal": {

&#x20;                     "value": "Month"

&#x20;                   }

&#x20;                 },

&#x20;                 "label\_3": {

&#x20;                   "stringVal": {

&#x20;                     "value": "Year"

&#x20;                   }

&#x20;                 }

&#x20;               },

&#x20;               "editorId": "stdtabgroup1"

&#x20;             }

&#x20;           ],

&#x20;           "editorId": "container82"

&#x20;         },

&#x20;         {

&#x20;           "type": "row",

&#x20;           "properties": {

&#x20;             "padding": {

&#x20;               "edgeInsets": {

&#x20;                 "top": 0,

&#x20;                 "right": 0,

&#x20;                 "bottom": 0,

&#x20;                 "left": 0,

&#x20;                 "rightToken": "lg",

&#x20;                 "leftToken": "lg"

&#x20;               }

&#x20;             },

&#x20;             "spacing": {

&#x20;               "stringVal": {

&#x20;                 "value": "md"

&#x20;               }

&#x20;             }

&#x20;           },

&#x20;           "children": \[

&#x20;             {

&#x20;               "type": "@summary\_card",

&#x20;               "properties": {

&#x20;                 "icon": {

&#x20;                   "stringVal": {

&#x20;                     "value": "trending\_up\_rounded"

&#x20;                   }

&#x20;                 },

&#x20;                 "color": {

&#x20;                   "stringVal": {

&#x20;                     "value": "success"

&#x20;                   }

&#x20;                 },

&#x20;                 "label": {

&#x20;                   "stringVal": {

&#x20;                     "value": "Completion"

&#x20;                   }

&#x20;                 },

&#x20;                 "value": {

&#x20;                   "stringVal": {

&#x20;                     "value": "88%"

&#x20;                   }

&#x20;                 }

&#x20;               },

&#x20;               "editorId": "summarycard1"

&#x20;             },

&#x20;             {

&#x20;               "type": "@summary\_card",

&#x20;               "properties": {

&#x20;                 "icon": {

&#x20;                   "stringVal": {

&#x20;                     "value": "local\_fire\_department\_rounded"

&#x20;                   }

&#x20;                 },

&#x20;                 "color": {

&#x20;                   "stringVal": {

&#x20;                     "value": "accent"

&#x20;                   }

&#x20;                 },

&#x20;                 "label": {

&#x20;                   "stringVal": {

&#x20;                     "value": "Best Streak"

&#x20;                   }

&#x20;                 },

&#x20;                 "value": {

&#x20;                   "stringVal": {

&#x20;                     "value": "24 Days"

&#x20;                   }

&#x20;                 }

&#x20;               },

&#x20;               "editorId": "summarycard2"

&#x20;             }

&#x20;           ],

&#x20;           "editorId": "row54"

&#x20;         },

&#x20;         {

&#x20;           "type": "column",

&#x20;           "properties": {

&#x20;             "padding": {

&#x20;               "edgeInsets": {

&#x20;                 "top": 0,

&#x20;                 "right": 0,

&#x20;                 "bottom": 0,

&#x20;                 "left": 0,

&#x20;                 "token": "lg"

&#x20;               }

&#x20;             },

&#x20;             "spacing": {

&#x20;               "stringVal": {

&#x20;                 "value": "md"

&#x20;               }

&#x20;             }

&#x20;           },

&#x20;           "children": \[

&#x20;             {

&#x20;               "type": "text",

&#x20;               "properties": {

&#x20;                 "content": {

&#x20;                   "stringVal": {

&#x20;                     "value": "Activity by Category"

&#x20;                   }

&#x20;                 },

&#x20;                 "style": {

&#x20;                   "textStyle": {

&#x20;                     "styleName": "title\_medium"

&#x20;                   }

&#x20;                 },

&#x20;                 "font\_weight": {

&#x20;                   "stringVal": {

&#x20;                     "value": "bold"

&#x20;                   }

&#x20;                 },

&#x20;                 "color": {

&#x20;                   "color": {

&#x20;                     "color": "primary\_text"

&#x20;                   }

&#x20;                 }

&#x20;               },

&#x20;               "editorId": "text92"

&#x20;             },

&#x20;             {

&#x20;               "type": "container",

&#x20;               "properties": {

&#x20;                 "bg": {

&#x20;                   "color": {

&#x20;                     "color": "surface"

&#x20;                   }

&#x20;                 },

&#x20;                 "radius": {

&#x20;                   "radius": {

&#x20;                     "topLeft": 0,

&#x20;                     "topRight": 0,

&#x20;                     "bottomLeft": 0,

&#x20;                     "bottomRight": 0,

&#x20;                     "token": "lg"

&#x20;                   }

&#x20;                 },

&#x20;                 "padding": {

&#x20;                   "edgeInsets": {

&#x20;                     "top": 0,

&#x20;                     "right": 0,

&#x20;                     "bottom": 0,

&#x20;                     "left": 0,

&#x20;                     "token": "lg"

&#x20;                   }

&#x20;                 },

&#x20;                 "border": {

&#x20;                   "border": {

&#x20;                     "width": 1,

&#x20;                     "color": "divider"

&#x20;                   }

&#x20;                 },

&#x20;                 "height": {

&#x20;                   "px": {

&#x20;                     "value": 240,

&#x20;                     "isInfinity": false

&#x20;                   }

&#x20;                 }

&#x20;               },

&#x20;               "children": \[

&#x20;                 {

&#x20;                   "type": "column",

&#x20;                   "properties": {

&#x20;                     "cross\_align": {

&#x20;                       "align": {

&#x20;                         "named": "stretch"

&#x20;                       }

&#x20;                     }

&#x20;                   },

&#x20;                   "children": \[

&#x20;                     {

&#x20;                       "type": "expanded",

&#x20;                       "children": \[

&#x20;                         {

&#x20;                           "type": "bar\_chart",

&#x20;                           "properties": {

&#x20;                             "data": {

&#x20;                               "stringVal": {

&#x20;                                 "value": "85,60,95,45"

&#x20;                               }

&#x20;                             },

&#x20;                             "labels": {

&#x20;                               "stringVal": {

&#x20;                                 "value": "Health,Focus,Mind,Fit"

&#x20;                               }

&#x20;                             },

&#x20;                             "color": {

&#x20;                               "color": {

&#x20;                                 "color": "primary"

&#x20;                               }

&#x20;                             },

&#x20;                             "bar\_radius": {

&#x20;                               "numberVal": {

&#x20;                                 "value": 4

&#x20;                               }

&#x20;                             },

&#x20;                             "bar\_width": {

&#x20;                               "numberVal": {

&#x20;                                 "value": 32

&#x20;                               }

&#x20;                             },

&#x20;                             "show\_grid": {

&#x20;                               "boolVal": {

&#x20;                                 "value": false

&#x20;                               }

&#x20;                             }

&#x20;                           },

&#x20;                           "editorId": "barchart1"

&#x20;                         }

&#x20;                       ],

&#x20;                       "editorId": "expanded18"

&#x20;                     },

&#x20;                     {

&#x20;                       "type": "sizedbox",

&#x20;                       "properties": {

&#x20;                         "height": {

&#x20;                           "stringVal": {

&#x20;                             "value": "md"

&#x20;                           }

&#x20;                         }

&#x20;                       },

&#x20;                       "editorId": "sizedbox4"

&#x20;                     },

&#x20;                     {

&#x20;                       "type": "column",

&#x20;                       "properties": {

&#x20;                         "spacing": {

&#x20;                           "stringVal": {

&#x20;                             "value": "xs"

&#x20;                           }

&#x20;                         }

&#x20;                       },

&#x20;                       "children": \[

&#x20;                         {

&#x20;                           "type": "@category\_performance",

&#x20;                           "properties": {

&#x20;                             "name": {

&#x20;                               "stringVal": {

&#x20;                                 "value": "Health"

&#x20;                               }

&#x20;                             },

&#x20;                             "percentage": {

&#x20;                               "stringVal": {

&#x20;                                 "value": "85%"

&#x20;                               }

&#x20;                             },

&#x20;                             "color": {

&#x20;                               "stringVal": {

&#x20;                                 "value": "primary"

&#x20;                               }

&#x20;                             }

&#x20;                           },

&#x20;                           "editorId": "categoryperformance1"

&#x20;                         },

&#x20;                         {

&#x20;                           "type": "@category\_performance",

&#x20;                           "properties": {

&#x20;                             "name": {

&#x20;                               "stringVal": {

&#x20;                                 "value": "Productivity"

&#x20;                               }

&#x20;                             },

&#x20;                             "percentage": {

&#x20;                               "stringVal": {

&#x20;                                 "value": "60%"

&#x20;                               }

&#x20;                             },

&#x20;                             "color": {

&#x20;                               "stringVal": {

&#x20;                                 "value": "accent"

&#x20;                               }

&#x20;                             }

&#x20;                           },

&#x20;                           "editorId": "categoryperformance2"

&#x20;                         },

&#x20;                         {

&#x20;                           "type": "@category\_performance",

&#x20;                           "properties": {

&#x20;                             "name": {

&#x20;                               "stringVal": {

&#x20;                                 "value": "Mindfulness"

&#x20;                               }

&#x20;                             },

&#x20;                             "percentage": {

&#x20;                               "stringVal": {

&#x20;                                 "value": "95%"

&#x20;                               }

&#x20;                             },

&#x20;                             "color": {

&#x20;                               "stringVal": {

&#x20;                                 "value": "success"

&#x20;                               }

&#x20;                             }

&#x20;                           },

&#x20;                           "editorId": "categoryperformance3"

&#x20;                         },

&#x20;                         {

&#x20;                           "type": "@category\_performance",

&#x20;                           "properties": {

&#x20;                             "name": {

&#x20;                               "stringVal": {

&#x20;                                 "value": "Fitness"

&#x20;                               }

&#x20;                             },

&#x20;                             "percentage": {

&#x20;                               "stringVal": {

&#x20;                                 "value": "45%"

&#x20;                               }

&#x20;                             },

&#x20;                             "color": {

&#x20;                               "stringVal": {

&#x20;                                 "value": "error"

&#x20;                               }

&#x20;                             }

&#x20;                           },

&#x20;                           "editorId": "categoryperformance4"

&#x20;                         }

&#x20;                       ],

&#x20;                       "editorId": "column68"

&#x20;                     }

&#x20;                   ],

&#x20;                   "editorId": "column67"

&#x20;                 }

&#x20;               ],

&#x20;               "editorId": "container83"

&#x20;             }

&#x20;           ],

&#x20;           "editorId": "column66"

&#x20;         },

&#x20;         {

&#x20;           "type": "column",

&#x20;           "properties": {

&#x20;             "padding": {

&#x20;               "edgeInsets": {

&#x20;                 "top": 0,

&#x20;                 "right": 0,

&#x20;                 "bottom": 0,

&#x20;                 "left": 0,

&#x20;                 "rightToken": "lg",

&#x20;                 "bottomToken": "lg",

&#x20;                 "leftToken": "lg"

&#x20;               }

&#x20;             },

&#x20;             "spacing": {

&#x20;               "stringVal": {

&#x20;                 "value": "md"

&#x20;               }

&#x20;             }

&#x20;           },

&#x20;           "children": \[

&#x20;             {

&#x20;               "type": "text",

&#x20;               "properties": {

&#x20;                 "content": {

&#x20;                   "stringVal": {

&#x20;                     "value": "Tracker Comparison"

&#x20;                   }

&#x20;                 },

&#x20;                 "style": {

&#x20;                   "textStyle": {

&#x20;                     "styleName": "title\_medium"

&#x20;                   }

&#x20;                 },

&#x20;                 "font\_weight": {

&#x20;                   "stringVal": {

&#x20;                     "value": "bold"

&#x20;                   }

&#x20;                 },

&#x20;                 "color": {

&#x20;                   "color": {

&#x20;                     "color": "primary\_text"

&#x20;                   }

&#x20;                 }

&#x20;               },

&#x20;               "editorId": "text93"

&#x20;             },

&#x20;             {

&#x20;               "type": "container",

&#x20;               "properties": {

&#x20;                 "bg": {

&#x20;                   "color": {

&#x20;                     "color": "surface"

&#x20;                   }

&#x20;                 },

&#x20;                 "radius": {

&#x20;                   "radius": {

&#x20;                     "topLeft": 0,

&#x20;                     "topRight": 0,

&#x20;                     "bottomLeft": 0,

&#x20;                     "bottomRight": 0,

&#x20;                     "token": "lg"

&#x20;                   }

&#x20;                 },

&#x20;                 "padding": {

&#x20;                   "edgeInsets": {

&#x20;                     "top": 0,

&#x20;                     "right": 0,

&#x20;                     "bottom": 0,

&#x20;                     "left": 0,

&#x20;                     "token": "lg"

&#x20;                   }

&#x20;                 },

&#x20;                 "border": {

&#x20;                   "border": {

&#x20;                     "width": 1,

&#x20;                     "color": "divider"

&#x20;                   }

&#x20;                 }

&#x20;               },

&#x20;               "children": \[

&#x20;                 {

&#x20;                   "type": "column",

&#x20;                   "properties": {

&#x20;                     "cross\_align": {

&#x20;                       "align": {

&#x20;                         "named": "stretch"

&#x20;                       }

&#x20;                     },

&#x20;                     "spacing": {

&#x20;                       "stringVal": {

&#x20;                         "value": "md"

&#x20;                       }

&#x20;                     }

&#x20;                   },

&#x20;                   "children": \[

&#x20;                     {

&#x20;                       "type": "row",

&#x20;                       "properties": {

&#x20;                         "align": {

&#x20;                           "align": {

&#x20;                             "named": "space\_between"

&#x20;                           }

&#x20;                         }

&#x20;                       },

&#x20;                       "children": \[

&#x20;                         {

&#x20;                           "type": "text",

&#x20;                           "properties": {

&#x20;                             "content": {

&#x20;                               "stringVal": {

&#x20;                                 "value": "Daily Completion Trend"

&#x20;                               }

&#x20;                             },

&#x20;                             "style": {

&#x20;                               "textStyle": {

&#x20;                                 "styleName": "body\_medium"

&#x20;                               }

&#x20;                             },

&#x20;                             "color": {

&#x20;                               "color": {

&#x20;                                 "color": "secondary\_text"

&#x20;                               }

&#x20;                             }

&#x20;                           },

&#x20;                           "editorId": "text94"

&#x20;                         },

&#x20;                         {

&#x20;                           "type": "icon",

&#x20;                           "properties": {

&#x20;                             "name": {

&#x20;                               "icon": {

&#x20;                                 "name": "insights\_rounded"

&#x20;                               }

&#x20;                             },

&#x20;                             "color": {

&#x20;                               "color": {

&#x20;                                 "color": "primary"

&#x20;                               }

&#x20;                             },

&#x20;                             "size": {

&#x20;                               "numberVal": {

&#x20;                                 "value": 20

&#x20;                               }

&#x20;                             }

&#x20;                           },

&#x20;                           "editorId": "icon33"

&#x20;                         }

&#x20;                       ],

&#x20;                       "editorId": "row55"

&#x20;                     },

&#x20;                     {

&#x20;                       "type": "container",

&#x20;                       "properties": {

&#x20;                         "height": {

&#x20;                           "px": {

&#x20;                             "value": 180,

&#x20;                             "isInfinity": false

&#x20;                           }

&#x20;                         }

&#x20;                       },

&#x20;                       "children": \[

&#x20;                         {

&#x20;                           "type": "line\_chart",

&#x20;                           "properties": {

&#x20;                             "data": {

&#x20;                               "stringVal": {

&#x20;                                 "value": "2,5,3,8,6,9,7"

&#x20;                               }

&#x20;                             },

&#x20;                             "labels": {

&#x20;                               "stringVal": {

&#x20;                                 "value": "M,T,W,T,F,S,S"

&#x20;                               }

&#x20;                             },

&#x20;                             "color": {

&#x20;                               "color": {

&#x20;                                 "color": "primary"

&#x20;                               }

&#x20;                             },

&#x20;                             "curved": {

&#x20;                               "boolVal": {

&#x20;                                 "value": true

&#x20;                               }

&#x20;                             },

&#x20;                             "filled": {

&#x20;                               "boolVal": {

&#x20;                                 "value": true

&#x20;                               }

&#x20;                             },

&#x20;                             "fill\_opacity": {

&#x20;                               "numberVal": {

&#x20;                                 "value": 0.1

&#x20;                               }

&#x20;                             },

&#x20;                             "show\_dots": {

&#x20;                               "boolVal": {

&#x20;                                 "value": true

&#x20;                               }

&#x20;                             }

&#x20;                           },

&#x20;                           "editorId": "linechart3"

&#x20;                         }

&#x20;                       ],

&#x20;                       "editorId": "container85"

&#x20;                     }

&#x20;                   ],

&#x20;                   "editorId": "column70"

&#x20;                 }

&#x20;               ],

&#x20;               "editorId": "container84"

&#x20;             }

&#x20;           ],

&#x20;           "editorId": "column69"

&#x20;         },

&#x20;         {

&#x20;           "type": "column",

&#x20;           "properties": {

&#x20;             "padding": {

&#x20;               "edgeInsets": {

&#x20;                 "top": 0,

&#x20;                 "right": 0,

&#x20;                 "bottom": 0,

&#x20;                 "left": 0,

&#x20;                 "rightToken": "lg",

&#x20;                 "bottomToken": "lg",

&#x20;                 "leftToken": "lg"

&#x20;               }

&#x20;             },

&#x20;             "spacing": {

&#x20;               "stringVal": {

&#x20;                 "value": "md"

&#x20;               }

&#x20;             }

&#x20;           },

&#x20;           "children": \[

&#x20;             {

&#x20;               "type": "text",

&#x20;               "properties": {

&#x20;                 "content": {

&#x20;                   "stringVal": {

&#x20;                     "value": "Top Performers"

&#x20;                   }

&#x20;                 },

&#x20;                 "style": {

&#x20;                   "textStyle": {

&#x20;                     "styleName": "title\_medium"

&#x20;                   }

&#x20;                 },

&#x20;                 "font\_weight": {

&#x20;                   "stringVal": {

&#x20;                     "value": "bold"

&#x20;                   }

&#x20;                 },

&#x20;                 "color": {

&#x20;                   "color": {

&#x20;                     "color": "primary\_text"

&#x20;                   }

&#x20;                 }

&#x20;               },

&#x20;               "editorId": "text95"

&#x20;             },

&#x20;             {

&#x20;               "type": "container",

&#x20;               "properties": {

&#x20;                 "bg": {

&#x20;                   "color": {

&#x20;                     "color": "surface"

&#x20;                   }

&#x20;                 },

&#x20;                 "radius": {

&#x20;                   "radius": {

&#x20;                     "topLeft": 0,

&#x20;                     "topRight": 0,

&#x20;                     "bottomLeft": 0,

&#x20;                     "bottomRight": 0,

&#x20;                     "token": "lg"

&#x20;                   }

&#x20;                 },

&#x20;                 "padding": {

&#x20;                   "edgeInsets": {

&#x20;                     "top": 0,

&#x20;                     "right": 0,

&#x20;                     "bottom": 0,

&#x20;                     "left": 0,

&#x20;                     "token": "md"

&#x20;                   }

&#x20;                 },

&#x20;                 "border": {

&#x20;                   "border": {

&#x20;                     "width": 1,

&#x20;                     "color": "divider"

&#x20;                   }

&#x20;                 }

&#x20;               },

&#x20;               "children": \[

&#x20;                 {

&#x20;                   "type": "column",

&#x20;                   "properties": {

&#x20;                     "spacing": {

&#x20;                       "stringVal": {

&#x20;                         "value": "sm"

&#x20;                       }

&#x20;                     }

&#x20;                   },

&#x20;                   "children": \[

&#x20;                     {

&#x20;                       "type": "row",

&#x20;                       "properties": {

&#x20;                         "spacing": {

&#x20;                           "stringVal": {

&#x20;                             "value": "md"

&#x20;                           }

&#x20;                         },

&#x20;                         "padding": {

&#x20;                           "edgeInsets": {

&#x20;                             "top": 0,

&#x20;                             "right": 0,

&#x20;                             "bottom": 0,

&#x20;                             "left": 0,

&#x20;                             "token": "md"

&#x20;                           }

&#x20;                         }

&#x20;                       },

&#x20;                       "children": \[

&#x20;                         {

&#x20;                           "type": "container",

&#x20;                           "properties": {

&#x20;                             "width": {

&#x20;                               "px": {

&#x20;                                 "value": 40,

&#x20;                                 "isInfinity": false

&#x20;                               }

&#x20;                             },

&#x20;                             "height": {

&#x20;                               "px": {

&#x20;                                 "value": 40,

&#x20;                                 "isInfinity": false

&#x20;                               }

&#x20;                             },

&#x20;                             "radius": {

&#x20;                               "radius": {

&#x20;                                 "topLeft": 0,

&#x20;                                 "topRight": 0,

&#x20;                                 "bottomLeft": 0,

&#x20;                                 "bottomRight": 0,

&#x20;                                 "token": "md"

&#x20;                               }

&#x20;                             },

&#x20;                             "bg": {

&#x20;                               "color": {

&#x20;                                 "color": "success",

&#x20;                                 "opacityPercent": 10

&#x20;                               }

&#x20;                             },

&#x20;                             "align\_child": {

&#x20;                               "align": {

&#x20;                                 "named": "center"

&#x20;                               }

&#x20;                             }

&#x20;                           },

&#x20;                           "children": \[

&#x20;                             {

&#x20;                               "type": "icon",

&#x20;                               "properties": {

&#x20;                                 "name": {

&#x20;                                   "icon": {

&#x20;                                     "name": "water\_drop\_rounded"

&#x20;                                   }

&#x20;                                 },

&#x20;                                 "color": {

&#x20;                                   "color": {

&#x20;                                     "color": "on\_primary"

&#x20;                                   }

&#x20;                                 },

&#x20;                                 "size": {

&#x20;                                   "numberVal": {

&#x20;                                     "value": 20

&#x20;                                   }

&#x20;                                 }

&#x20;                               },

&#x20;                               "editorId": "icon34"

&#x20;                             }

&#x20;                           ],

&#x20;                           "editorId": "container87"

&#x20;                         },

&#x20;                         {

&#x20;                           "type": "expanded",

&#x20;                           "children": \[

&#x20;                             {

&#x20;                               "type": "column",

&#x20;                               "properties": {

&#x20;                                 "cross\_align": {

&#x20;                                   "align": {

&#x20;                                     "named": "start"

&#x20;                                   }

&#x20;                                 }

&#x20;                               },

&#x20;                               "children": \[

&#x20;                                 {

&#x20;                                   "type": "text",

&#x20;                                   "properties": {

&#x20;                                     "content": {

&#x20;                                       "stringVal": {

&#x20;                                         "value": "Hydration Goal"

&#x20;                                       }

&#x20;                                     },

&#x20;                                     "style": {

&#x20;                                       "textStyle": {

&#x20;                                         "styleName": "body\_large"

&#x20;                                       }

&#x20;                                     },

&#x20;                                     "font\_weight": {

&#x20;                                       "numberVal": {

&#x20;                                         "value": 600

&#x20;                                       }

&#x20;                                     }

&#x20;                                   },

&#x20;                                   "editorId": "text96"

&#x20;                                 },

&#x20;                                 {

&#x20;                                   "type": "text",

&#x20;                                   "properties": {

&#x20;                                     "content": {

&#x20;                                       "stringVal": {

&#x20;                                         "value": "98% consistency"

&#x20;                                       }

&#x20;                                     },

&#x20;                                     "style": {

&#x20;                                       "textStyle": {

&#x20;                                         "styleName": "label\_small"

&#x20;                                       }

&#x20;                                     },

&#x20;                                     "color": {

&#x20;                                       "color": {

&#x20;                                         "color": "secondary\_text"

&#x20;                                       }

&#x20;                                     }

&#x20;                                   },

&#x20;                                   "editorId": "text97"

&#x20;                                 }

&#x20;                               ],

&#x20;                               "editorId": "column73"

&#x20;                             }

&#x20;                           ],

&#x20;                           "editorId": "expanded19"

&#x20;                         },

&#x20;                         {

&#x20;                           "type": "text",

&#x20;                           "properties": {

&#x20;                             "content": {

&#x20;                               "stringVal": {

&#x20;                                 "value": "🔥 15"

&#x20;                               }

&#x20;                             },

&#x20;                             "style": {

&#x20;                               "textStyle": {

&#x20;                                 "styleName": "body\_medium"

&#x20;                               }

&#x20;                             },

&#x20;                             "color": {

&#x20;                               "color": {

&#x20;                                 "color": "on\_surface"

&#x20;                               }

&#x20;                             },

&#x20;                             "font\_weight": {

&#x20;                               "stringVal": {

&#x20;                                 "value": "bold"

&#x20;                               }

&#x20;                             }

&#x20;                           },

&#x20;                           "editorId": "text98"

&#x20;                         }

&#x20;                       ],

&#x20;                       "editorId": "row56"

&#x20;                     },

&#x20;                     {

&#x20;                       "type": "divider",

&#x20;                       "properties": {

&#x20;                         "color": {

&#x20;                           "color": {

&#x20;                             "color": "divider"

&#x20;                           }

&#x20;                         }

&#x20;                       },

&#x20;                       "editorId": "divider1"

&#x20;                     },

&#x20;                     {

&#x20;                       "type": "row",

&#x20;                       "properties": {

&#x20;                         "spacing": {

&#x20;                           "stringVal": {

&#x20;                             "value": "md"

&#x20;                           }

&#x20;                         },

&#x20;                         "padding": {

&#x20;                           "edgeInsets": {

&#x20;                             "top": 0,

&#x20;                             "right": 0,

&#x20;                             "bottom": 0,

&#x20;                             "left": 0,

&#x20;                             "token": "md"

&#x20;                           }

&#x20;                         }

&#x20;                       },

&#x20;                       "children": \[

&#x20;                         {

&#x20;                           "type": "container",

&#x20;                           "properties": {

&#x20;                             "width": {

&#x20;                               "px": {

&#x20;                                 "value": 40,

&#x20;                                 "isInfinity": false

&#x20;                               }

&#x20;                             },

&#x20;                             "height": {

&#x20;                               "px": {

&#x20;                                 "value": 40,

&#x20;                                 "isInfinity": false

&#x20;                               }

&#x20;                             },

&#x20;                             "radius": {

&#x20;                               "radius": {

&#x20;                                 "topLeft": 0,

&#x20;                                 "topRight": 0,

&#x20;                                 "bottomLeft": 0,

&#x20;                                 "bottomRight": 0,

&#x20;                                 "token": "md"

&#x20;                               }

&#x20;                             },

&#x20;                             "bg": {

&#x20;                               "color": {

&#x20;                                 "color": "accent",

&#x20;                                 "opacityPercent": 10

&#x20;                               }

&#x20;                             },

&#x20;                             "align\_child": {

&#x20;                               "align": {

&#x20;                                 "named": "center"

&#x20;                               }

&#x20;                             }

&#x20;                           },

&#x20;                           "children": \[

&#x20;                             {

&#x20;                               "type": "icon",

&#x20;                               "properties": {

&#x20;                                 "name": {

&#x20;                                   "icon": {

&#x20;                                     "name": "menu\_book\_rounded"

&#x20;                                   }

&#x20;                                 },

&#x20;                                 "color": {

&#x20;                                   "color": {

&#x20;                                     "color": "on\_primary"

&#x20;                                   }

&#x20;                                 },

&#x20;                                 "size": {

&#x20;                                   "numberVal": {

&#x20;                                     "value": 20

&#x20;                                   }

&#x20;                                 }

&#x20;                               },

&#x20;                               "editorId": "icon35"

&#x20;                             }

&#x20;                           ],

&#x20;                           "editorId": "container88"

&#x20;                         },

&#x20;                         {

&#x20;                           "type": "expanded",

&#x20;                           "children": \[

&#x20;                             {

&#x20;                               "type": "column",

&#x20;                               "properties": {

&#x20;                                 "cross\_align": {

&#x20;                                   "align": {

&#x20;                                     "named": "start"

&#x20;                                   }

&#x20;                                 }

&#x20;                               },

&#x20;                               "children": \[

&#x20;                                 {

&#x20;                                   "type": "text",

&#x20;                                   "properties": {

&#x20;                                     "content": {

&#x20;                                       "stringVal": {

&#x20;                                         "value": "Read 20 Pages"

&#x20;                                       }

&#x20;                                     },

&#x20;                                     "style": {

&#x20;                                       "textStyle": {

&#x20;                                         "styleName": "body\_large"

&#x20;                                       }

&#x20;                                     },

&#x20;                                     "font\_weight": {

&#x20;                                       "numberVal": {

&#x20;                                         "value": 600

&#x20;                                       }

&#x20;                                     }

&#x20;                                   },

&#x20;                                   "editorId": "text99"

&#x20;                                 },

&#x20;                                 {

&#x20;                                   "type": "text",

&#x20;                                   "properties": {

&#x20;                                     "content": {

&#x20;                                       "stringVal": {

&#x20;                                         "value": "82% consistency"

&#x20;                                       }

&#x20;                                     },

&#x20;                                     "style": {

&#x20;                                       "textStyle": {

&#x20;                                         "styleName": "label\_small"

&#x20;                                       }

&#x20;                                     },

&#x20;                                     "color": {

&#x20;                                       "color": {

&#x20;                                         "color": "secondary\_text"

&#x20;                                       }

&#x20;                                     }

&#x20;                                   },

&#x20;                                   "editorId": "text100"

&#x20;                                 }

&#x20;                               ],

&#x20;                               "editorId": "column74"

&#x20;                             }

&#x20;                           ],

&#x20;                           "editorId": "expanded20"

&#x20;                         },

&#x20;                         {

&#x20;                           "type": "text",

&#x20;                           "properties": {

&#x20;                             "content": {

&#x20;                               "stringVal": {

&#x20;                                 "value": "🔥 8"

&#x20;                               }

&#x20;                             },

&#x20;                             "style": {

&#x20;                               "textStyle": {

&#x20;                                 "styleName": "body\_medium"

&#x20;                               }

&#x20;                             },

&#x20;                             "color": {

&#x20;                               "color": {

&#x20;                                 "color": "on\_surface"

&#x20;                               }

&#x20;                             },

&#x20;                             "font\_weight": {

&#x20;                               "stringVal": {

&#x20;                                 "value": "bold"

&#x20;                               }

&#x20;                             }

&#x20;                           },

&#x20;                           "editorId": "text101"

&#x20;                         }

&#x20;                       ],

&#x20;                       "editorId": "row57"

&#x20;                     }

&#x20;                   ],

&#x20;                   "editorId": "column72"

&#x20;                 }

&#x20;               ],

&#x20;               "editorId": "container86"

&#x20;             }

&#x20;           ],

&#x20;           "editorId": "column71"

&#x20;         },

&#x20;         {

&#x20;           "type": "column",

&#x20;           "properties": {

&#x20;             "padding": {

&#x20;               "edgeInsets": {

&#x20;                 "top": 0,

&#x20;                 "right": 0,

&#x20;                 "bottom": 0,

&#x20;                 "left": 0,

&#x20;                 "rightToken": "lg",

&#x20;                 "bottomToken": "lg",

&#x20;                 "leftToken": "lg"

&#x20;               }

&#x20;             },

&#x20;             "spacing": {

&#x20;               "stringVal": {

&#x20;                 "value": "md"

&#x20;               }

&#x20;             }

&#x20;           },

&#x20;           "children": \[

&#x20;             {

&#x20;               "type": "text",

&#x20;               "properties": {

&#x20;                 "content": {

&#x20;                   "stringVal": {

&#x20;                     "value": "Room for Improvement"

&#x20;                   }

&#x20;                 },

&#x20;                 "style": {

&#x20;                   "textStyle": {

&#x20;                     "styleName": "title\_medium"

&#x20;                   }

&#x20;                 },

&#x20;                 "font\_weight": {

&#x20;                   "stringVal": {

&#x20;                     "value": "bold"

&#x20;                   }

&#x20;                 },

&#x20;                 "color": {

&#x20;                   "color": {

&#x20;                     "color": "primary\_text"

&#x20;                   }

&#x20;                 }

&#x20;               },

&#x20;               "editorId": "text102"

&#x20;             },

&#x20;             {

&#x20;               "type": "container",

&#x20;               "properties": {

&#x20;                 "bg": {

&#x20;                   "color": {

&#x20;                     "color": "surface"

&#x20;                   }

&#x20;                 },

&#x20;                 "radius": {

&#x20;                   "radius": {

&#x20;                     "topLeft": 0,

&#x20;                     "topRight": 0,

&#x20;                     "bottomLeft": 0,

&#x20;                     "bottomRight": 0,

&#x20;                     "token": "lg"

&#x20;                   }

&#x20;                 },

&#x20;                 "padding": {

&#x20;                   "edgeInsets": {

&#x20;                     "top": 0,

&#x20;                     "right": 0,

&#x20;                     "bottom": 0,

&#x20;                     "left": 0,

&#x20;                     "token": "md"

&#x20;                   }

&#x20;                 },

&#x20;                 "border": {

&#x20;                   "border": {

&#x20;                     "width": 1,

&#x20;                     "color": "divider"

&#x20;                   }

&#x20;                 }

&#x20;               },

&#x20;               "children": \[

&#x20;                 {

&#x20;                   "type": "row",

&#x20;                   "properties": {

&#x20;                     "spacing": {

&#x20;                       "stringVal": {

&#x20;                         "value": "md"

&#x20;                       }

&#x20;                     },

&#x20;                     "padding": {

&#x20;                       "edgeInsets": {

&#x20;                         "top": 0,

&#x20;                         "right": 0,

&#x20;                         "bottom": 0,

&#x20;                         "left": 0,

&#x20;                         "token": "md"

&#x20;                       }

&#x20;                     }

&#x20;                   },

&#x20;                   "children": \[

&#x20;                     {

&#x20;                       "type": "container",

&#x20;                       "properties": {

&#x20;                         "width": {

&#x20;                           "px": {

&#x20;                             "value": 40,

&#x20;                             "isInfinity": false

&#x20;                           }

&#x20;                         },

&#x20;                         "height": {

&#x20;                           "px": {

&#x20;                             "value": 40,

&#x20;                             "isInfinity": false

&#x20;                           }

&#x20;                         },

&#x20;                         "radius": {

&#x20;                           "radius": {

&#x20;                             "topLeft": 0,

&#x20;                             "topRight": 0,

&#x20;                             "bottomLeft": 0,

&#x20;                             "bottomRight": 0,

&#x20;                             "token": "md"

&#x20;                           }

&#x20;                         },

&#x20;                         "bg": {

&#x20;                           "color": {

&#x20;                             "color": "error",

&#x20;                             "opacityPercent": 10

&#x20;                           }

&#x20;                         },

&#x20;                         "align\_child": {

&#x20;                           "align": {

&#x20;                             "named": "center"

&#x20;                           }

&#x20;                         }

&#x20;                       },

&#x20;                       "children": \[

&#x20;                         {

&#x20;                           "type": "icon",

&#x20;                           "properties": {

&#x20;                             "name": {

&#x20;                               "icon": {

&#x20;                                 "name": "fitness\_center\_rounded"

&#x20;                               }

&#x20;                             },

&#x20;                             "color": {

&#x20;                               "color": {

&#x20;                                 "color": "on\_primary"

&#x20;                               }

&#x20;                             },

&#x20;                             "size": {

&#x20;                               "numberVal": {

&#x20;                                 "value": 20

&#x20;                               }

&#x20;                             }

&#x20;                           },

&#x20;                           "editorId": "icon36"

&#x20;                         }

&#x20;                       ],

&#x20;                       "editorId": "container90"

&#x20;                     },

&#x20;                     {

&#x20;                       "type": "expanded",

&#x20;                       "children": \[

&#x20;                         {

&#x20;                           "type": "column",

&#x20;                           "properties": {

&#x20;                             "cross\_align": {

&#x20;                               "align": {

&#x20;                                 "named": "start"

&#x20;                               }

&#x20;                             }

&#x20;                           },

&#x20;                           "children": \[

&#x20;                             {

&#x20;                               "type": "text",

&#x20;                               "properties": {

&#x20;                                 "content": {

&#x20;                                   "stringVal": {

&#x20;                                     "value": "Morning Workout"

&#x20;                                   }

&#x20;                                 },

&#x20;                                 "style": {

&#x20;                                   "textStyle": {

&#x20;                                     "styleName": "body\_large"

&#x20;                                   }

&#x20;                                 },

&#x20;                                 "font\_weight": {

&#x20;                                   "numberVal": {

&#x20;                                     "value": 600

&#x20;                                   }

&#x20;                                 }

&#x20;                               },

&#x20;                               "editorId": "text103"

&#x20;                             },

&#x20;                             {

&#x20;                               "type": "text",

&#x20;                               "properties": {

&#x20;                                 "content": {

&#x20;                                   "stringVal": {

&#x20;                                     "value": "42% consistency"

&#x20;                                   }

&#x20;                                 },

&#x20;                                 "style": {

&#x20;                                   "textStyle": {

&#x20;                                     "styleName": "label\_small"

&#x20;                                   }

&#x20;                                 },

&#x20;                                 "color": {

&#x20;                                   "color": {

&#x20;                                     "color": "secondary\_text"

&#x20;                                   }

&#x20;                                 }

&#x20;                               },

&#x20;                               "editorId": "text104"

&#x20;                             }

&#x20;                           ],

&#x20;                           "editorId": "column76"

&#x20;                         }

&#x20;                       ],

&#x20;                       "editorId": "expanded21"

&#x20;                     },

&#x20;                     {

&#x20;                       "type": "@std.button",

&#x20;                       "properties": {

&#x20;                         "content": {

&#x20;                           "stringVal": {

&#x20;                             "value": "Boost"

&#x20;                           }

&#x20;                         },

&#x20;                         "variant": {

&#x20;                           "stringVal": {

&#x20;                             "value": "outline"

&#x20;                           }

&#x20;                         },

&#x20;                         "size": {

&#x20;                           "stringVal": {

&#x20;                             "value": "small"

&#x20;                           }

&#x20;                         }

&#x20;                       },

&#x20;                       "editorId": "stdbutton6"

&#x20;                     }

&#x20;                   ],

&#x20;                   "editorId": "row58"

&#x20;                 }

&#x20;               ],

&#x20;               "editorId": "container89"

&#x20;             }

&#x20;           ],

&#x20;           "editorId": "column75"

&#x20;         },

&#x20;         {

&#x20;           "type": "sizedbox",

&#x20;           "properties": {

&#x20;             "height": {

&#x20;               "stringVal": {

&#x20;                 "value": "xl"

&#x20;               }

&#x20;             }

&#x20;           },

&#x20;           "editorId": "sizedbox5"

&#x20;         }

&#x20;       ],

&#x20;       "editorId": "column64"

&#x20;     }

&#x20;   ],

&#x20;   "editorId": "scaffold7"

&#x20; }

}

```



\### 8. Nutrition Tracker



\- Frame ID: `frame9`

\- Original page prompt: "Specialized dashboard for daily calorie and macro tracking with meal sections and manual food entry."

\- Follow-up prompts: \_None\_



\#### DslDocument (JSON)



```json

{

&#x20; "root": {

&#x20;   "type": "scaffold",

&#x20;   "properties": {

&#x20;     "bg": {

&#x20;       "color": {

&#x20;         "color": "background"

&#x20;       }

&#x20;     }

&#x20;   },

&#x20;   "children": \[

&#x20;     {

&#x20;       "type": "column",

&#x20;       "properties": {

&#x20;         "cross\_align": {

&#x20;           "align": {

&#x20;             "named": "stretch"

&#x20;           }

&#x20;         }

&#x20;       },

&#x20;       "children": \[

&#x20;         {

&#x20;           "type": "container",

&#x20;           "properties": {

&#x20;             "bg": {

&#x20;               "color": {

&#x20;                 "color": "surface"

&#x20;               }

&#x20;             },

&#x20;             "padding": {

&#x20;               "edgeInsets": {

&#x20;                 "top": 0,

&#x20;                 "right": 0,

&#x20;                 "bottom": 0,

&#x20;                 "left": 0,

&#x20;                 "topToken": "lg",

&#x20;                 "rightToken": "md",

&#x20;                 "bottomToken": "lg",

&#x20;                 "leftToken": "md"

&#x20;               }

&#x20;             },

&#x20;             "border": {

&#x20;               "borderSided": {

&#x20;                 "side": "bottom",

&#x20;                 "width": 1,

&#x20;                 "color": "divider"

&#x20;               }

&#x20;             }

&#x20;           },

&#x20;           "children": \[

&#x20;             {

&#x20;               "type": "column",

&#x20;               "properties": {

&#x20;                 "spacing": {

&#x20;                   "stringVal": {

&#x20;                     "value": "md"

&#x20;                   }

&#x20;                 }

&#x20;               },

&#x20;               "children": \[

&#x20;                 {

&#x20;                   "type": "row",

&#x20;                   "properties": {

&#x20;                     "align": {

&#x20;                       "align": {

&#x20;                         "named": "space\_between"

&#x20;                       }

&#x20;                     },

&#x20;                     "cross\_align": {

&#x20;                       "align": {

&#x20;                         "named": "center"

&#x20;                       }

&#x20;                     }

&#x20;                   },

&#x20;                   "children": \[

&#x20;                     {

&#x20;                       "type": "text",

&#x20;                       "properties": {

&#x20;                         "content": {

&#x20;                           "stringVal": {

&#x20;                             "value": "Nutrition"

&#x20;                           }

&#x20;                         },

&#x20;                         "style": {

&#x20;                           "textStyle": {

&#x20;                             "styleName": "headline\_medium"

&#x20;                           }

&#x20;                         },

&#x20;                         "font\_weight": {

&#x20;                           "stringVal": {

&#x20;                             "value": "bold"

&#x20;                           }

&#x20;                         },

&#x20;                         "color": {

&#x20;                           "color": {

&#x20;                             "color": "primary\_text"

&#x20;                           }

&#x20;                         }

&#x20;                       },

&#x20;                       "editorId": "text105"

&#x20;                     },

&#x20;                     {

&#x20;                       "type": "iconbutton",

&#x20;                       "properties": {

&#x20;                         "name": {

&#x20;                           "icon": {

&#x20;                             "name": "calendar\_today\_rounded"

&#x20;                           }

&#x20;                         },

&#x20;                         "color": {

&#x20;                           "color": {

&#x20;                             "color": "primary\_text"

&#x20;                           }

&#x20;                         },

&#x20;                         "size": {

&#x20;                           "numberVal": {

&#x20;                             "value": 22

&#x20;                           }

&#x20;                         }

&#x20;                       },

&#x20;                       "editorId": "iconbutton15"

&#x20;                     }

&#x20;                   ],

&#x20;                   "editorId": "row59"

&#x20;                 },

&#x20;                 {

&#x20;                   "type": "row",

&#x20;                   "properties": {

&#x20;                     "align": {

&#x20;                       "align": {

&#x20;                         "named": "space\_between"

&#x20;                       }

&#x20;                     },

&#x20;                     "cross\_align": {

&#x20;                       "align": {

&#x20;                         "named": "center"

&#x20;                       }

&#x20;                     }

&#x20;                   },

&#x20;                   "children": \[

&#x20;                     {

&#x20;                       "type": "iconbutton",

&#x20;                       "properties": {

&#x20;                         "name": {

&#x20;                           "icon": {

&#x20;                             "name": "chevron\_left\_rounded"

&#x20;                           }

&#x20;                         },

&#x20;                         "size": {

&#x20;                           "numberVal": {

&#x20;                             "value": 24

&#x20;                           }

&#x20;                         }

&#x20;                       },

&#x20;                       "editorId": "iconbutton2"

&#x20;                     },

&#x20;                     {

&#x20;                       "type": "text",

&#x20;                       "properties": {

&#x20;                         "content": {

&#x20;                           "stringVal": {

&#x20;                             "value": "Today, Oct 24"

&#x20;                           }

&#x20;                         },

&#x20;                         "style": {

&#x20;                           "textStyle": {

&#x20;                             "styleName": "title\_medium"

&#x20;                           }

&#x20;                         },

&#x20;                         "font\_weight": {

&#x20;                           "numberVal": {

&#x20;                             "value": 600

&#x20;                           }

&#x20;                         }

&#x20;                       },

&#x20;                       "editorId": "text106"

&#x20;                     },

&#x20;                     {

&#x20;                       "type": "iconbutton",

&#x20;                       "properties": {

&#x20;                         "name": {

&#x20;                           "icon": {

&#x20;                             "name": "chevron\_right\_rounded"

&#x20;                           }

&#x20;                         },

&#x20;                         "size": {

&#x20;                           "numberVal": {

&#x20;                             "value": 24

&#x20;                           }

&#x20;                         }

&#x20;                       },

&#x20;                       "editorId": "iconbutton3"

&#x20;                     }

&#x20;                   ],

&#x20;                   "editorId": "row60"

&#x20;                 }

&#x20;               ],

&#x20;               "editorId": "column78"

&#x20;             }

&#x20;           ],

&#x20;           "editorId": "container91"

&#x20;         },

&#x20;         {

&#x20;           "type": "expanded",

&#x20;           "children": \[

&#x20;             {

&#x20;               "type": "column",

&#x20;               "properties": {

&#x20;                 "scroll": {

&#x20;                   "boolVal": {

&#x20;                     "value": true

&#x20;                   }

&#x20;                 },

&#x20;                 "padding": {

&#x20;                   "edgeInsets": {

&#x20;                     "top": 0,

&#x20;                     "right": 0,

&#x20;                     "bottom": 0,

&#x20;                     "left": 0,

&#x20;                     "token": "lg"

&#x20;                   }

&#x20;                 },

&#x20;                 "spacing": {

&#x20;                   "stringVal": {

&#x20;                     "value": "lg"

&#x20;                   }

&#x20;                 },

&#x20;                 "cross\_align": {

&#x20;                   "align": {

&#x20;                     "named": "stretch"

&#x20;                   }

&#x20;                 }

&#x20;               },

&#x20;               "children": \[

&#x20;                 {

&#x20;                   "type": "container",

&#x20;                   "properties": {

&#x20;                     "bg": {

&#x20;                       "color": {

&#x20;                         "color": "surface"

&#x20;                       }

&#x20;                     },

&#x20;                     "radius": {

&#x20;                       "radius": {

&#x20;                         "topLeft": 0,

&#x20;                         "topRight": 0,

&#x20;                         "bottomLeft": 0,

&#x20;                         "bottomRight": 0,

&#x20;                         "token": "lg"

&#x20;                       }

&#x20;                     },

&#x20;                     "padding": {

&#x20;                       "edgeInsets": {

&#x20;                         "top": 0,

&#x20;                         "right": 0,

&#x20;                         "bottom": 0,

&#x20;                         "left": 0,

&#x20;                         "token": "lg"

&#x20;                       }

&#x20;                     },

&#x20;                     "border": {

&#x20;                       "border": {

&#x20;                         "width": 1,

&#x20;                         "color": "divider"

&#x20;                       }

&#x20;                     }

&#x20;                   },

&#x20;                   "children": \[

&#x20;                     {

&#x20;                       "type": "row",

&#x20;                       "properties": {

&#x20;                         "spacing": {

&#x20;                           "stringVal": {

&#x20;                             "value": "lg"

&#x20;                           }

&#x20;                         },

&#x20;                         "cross\_align": {

&#x20;                           "align": {

&#x20;                             "named": "center"

&#x20;                           }

&#x20;                         }

&#x20;                       },

&#x20;                       "children": \[

&#x20;                         {

&#x20;                           "type": "container",

&#x20;                           "properties": {

&#x20;                             "width": {

&#x20;                               "px": {

&#x20;                                 "value": 140,

&#x20;                                 "isInfinity": false

&#x20;                               }

&#x20;                             },

&#x20;                             "height": {

&#x20;                               "px": {

&#x20;                                 "value": 140,

&#x20;                                 "isInfinity": false

&#x20;                               }

&#x20;                             }

&#x20;                           },

&#x20;                           "children": \[

&#x20;                             {

&#x20;                               "type": "@std.pie\_chart",

&#x20;                               "properties": {

&#x20;                                 "variant": {

&#x20;                                   "stringVal": {

&#x20;                                     "value": "donut"

&#x20;                                   }

&#x20;                                 },

&#x20;                                 "size": {

&#x20;                                   "stringVal": {

&#x20;                                     "value": "medium"

&#x20;                                   }

&#x20;                                 },

&#x20;                                 "data": {

&#x20;                                   "stringVal": {

&#x20;                                     "value": "1420, 780"

&#x20;                                   }

&#x20;                                 },

&#x20;                                 "colors": {

&#x20;                                   "stringVal": {

&#x20;                                     "value": "primary,divider"

&#x20;                                   }

&#x20;                                 },

&#x20;                                 "center\_value": {

&#x20;                                   "stringVal": {

&#x20;                                     "value": "1,420"

&#x20;                                   }

&#x20;                                 },

&#x20;                                 "center\_label": {

&#x20;                                   "stringVal": {

&#x20;                                     "value": "kcal"

&#x20;                                   }

&#x20;                                 },

&#x20;                                 "legend": {

&#x20;                                   "stringVal": {

&#x20;                                     "value": "hidden"

&#x20;                                   }

&#x20;                                 },

&#x20;                                 "ring": {

&#x20;                                   "stringVal": {

&#x20;                                     "value": "thick"

&#x20;                                   }

&#x20;                                 },

&#x20;                                 "gap": {

&#x20;                                   "stringVal": {

&#x20;                                     "value": "none"

&#x20;                                   }

&#x20;                                 }

&#x20;                               },

&#x20;                               "editorId": "stdpiechart1"

&#x20;                             }

&#x20;                           ],

&#x20;                           "editorId": "container93"

&#x20;                         },

&#x20;                         {

&#x20;                           "type": "expanded",

&#x20;                           "children": \[

&#x20;                             {

&#x20;                               "type": "column",

&#x20;                               "properties": {

&#x20;                                 "spacing": {

&#x20;                                   "stringVal": {

&#x20;                                     "value": "sm"

&#x20;                                   }

&#x20;                                 }

&#x20;                               },

&#x20;                               "children": \[

&#x20;                                 {

&#x20;                                   "type": "text",

&#x20;                                   "properties": {

&#x20;                                     "content": {

&#x20;                                       "stringVal": {

&#x20;                                         "value": "Daily Goal"

&#x20;                                       }

&#x20;                                     },

&#x20;                                     "style": {

&#x20;                                       "textStyle": {

&#x20;                                         "styleName": "label\_small"

&#x20;                                       }

&#x20;                                     },

&#x20;                                     "color": {

&#x20;                                       "color": {

&#x20;                                         "color": "secondary\_text"

&#x20;                                       }

&#x20;                                     }

&#x20;                                   },

&#x20;                                   "editorId": "text107"

&#x20;                                 },

&#x20;                                 {

&#x20;                                   "type": "text",

&#x20;                                   "properties": {

&#x20;                                     "content": {

&#x20;                                       "stringVal": {

&#x20;                                         "value": "2,200 kcal"

&#x20;                                       }

&#x20;                                     },

&#x20;                                     "style": {

&#x20;                                       "textStyle": {

&#x20;                                         "styleName": "title\_large"

&#x20;                                       }

&#x20;                                     },

&#x20;                                     "font\_weight": {

&#x20;                                       "stringVal": {

&#x20;                                         "value": "bold"

&#x20;                                       }

&#x20;                                     },

&#x20;                                     "color": {

&#x20;                                       "color": {

&#x20;                                         "color": "primary\_text"

&#x20;                                       }

&#x20;                                     }

&#x20;                                   },

&#x20;                                   "editorId": "text108"

&#x20;                                 },

&#x20;                                 {

&#x20;                                   "type": "divider",

&#x20;                                   "properties": {

&#x20;                                     "thickness": {

&#x20;                                       "numberVal": {

&#x20;                                         "value": 1

&#x20;                                       }

&#x20;                                     },

&#x20;                                     "color": {

&#x20;                                       "color": {

&#x20;                                         "color": "divider"

&#x20;                                       }

&#x20;                                     }

&#x20;                                   },

&#x20;                                   "editorId": "divider5"

&#x20;                                 },

&#x20;                                 {

&#x20;                                   "type": "row",

&#x20;                                   "properties": {

&#x20;                                     "align": {

&#x20;                                       "align": {

&#x20;                                         "named": "space\_between"

&#x20;                                       }

&#x20;                                     }

&#x20;                                   },

&#x20;                                   "children": \[

&#x20;                                     {

&#x20;                                       "type": "text",

&#x20;                                       "properties": {

&#x20;                                         "content": {

&#x20;                                           "stringVal": {

&#x20;                                             "value": "Remaining"

&#x20;                                           }

&#x20;                                         },

&#x20;                                         "style": {

&#x20;                                           "textStyle": {

&#x20;                                             "styleName": "body\_small"

&#x20;                                           }

&#x20;                                         },

&#x20;                                         "color": {

&#x20;                                           "color": {

&#x20;                                             "color": "secondary\_text"

&#x20;                                           }

&#x20;                                         }

&#x20;                                       },

&#x20;                                       "editorId": "text109"

&#x20;                                     },

&#x20;                                     {

&#x20;                                       "type": "text",

&#x20;                                       "properties": {

&#x20;                                         "content": {

&#x20;                                           "stringVal": {

&#x20;                                             "value": "780 kcal"

&#x20;                                           }

&#x20;                                         },

&#x20;                                         "style": {

&#x20;                                           "textStyle": {

&#x20;                                             "styleName": "body\_small"

&#x20;                                           }

&#x20;                                         },

&#x20;                                         "color": {

&#x20;                                           "color": {

&#x20;                                             "color": "primary"

&#x20;                                           }

&#x20;                                         },

&#x20;                                         "font\_weight": {

&#x20;                                           "stringVal": {

&#x20;                                             "value": "bold"

&#x20;                                           }

&#x20;                                         }

&#x20;                                       },

&#x20;                                       "editorId": "text110"

&#x20;                                     }

&#x20;                                   ],

&#x20;                                   "editorId": "row62"

&#x20;                                 }

&#x20;                               ],

&#x20;                               "editorId": "column80"

&#x20;                             }

&#x20;                           ],

&#x20;                           "editorId": "expanded23"

&#x20;                         }

&#x20;                       ],

&#x20;                       "editorId": "row61"

&#x20;                     }

&#x20;                   ],

&#x20;                   "editorId": "container92"

&#x20;                 },

&#x20;                 {

&#x20;                   "type": "container",

&#x20;                   "properties": {

&#x20;                     "bg": {

&#x20;                       "color": {

&#x20;                         "color": "surface"

&#x20;                       }

&#x20;                     },

&#x20;                     "radius": {

&#x20;                       "radius": {

&#x20;                         "topLeft": 0,

&#x20;                         "topRight": 0,

&#x20;                         "bottomLeft": 0,

&#x20;                         "bottomRight": 0,

&#x20;                         "token": "lg"

&#x20;                       }

&#x20;                     },

&#x20;                     "padding": {

&#x20;                       "edgeInsets": {

&#x20;                         "top": 0,

&#x20;                         "right": 0,

&#x20;                         "bottom": 0,

&#x20;                         "left": 0,

&#x20;                         "token": "lg"

&#x20;                       }

&#x20;                     },

&#x20;                     "border": {

&#x20;                       "border": {

&#x20;                         "width": 1,

&#x20;                         "color": "divider"

&#x20;                       }

&#x20;                     }

&#x20;                   },

&#x20;                   "children": \[

&#x20;                     {

&#x20;                       "type": "column",

&#x20;                       "properties": {

&#x20;                         "spacing": {

&#x20;                           "stringVal": {

&#x20;                             "value": "md"

&#x20;                           }

&#x20;                         }

&#x20;                       },

&#x20;                       "children": \[

&#x20;                         {

&#x20;                           "type": "text",

&#x20;                           "properties": {

&#x20;                             "content": {

&#x20;                               "stringVal": {

&#x20;                                 "value": "Macros Breakdown"

&#x20;                               }

&#x20;                             },

&#x20;                             "style": {

&#x20;                               "textStyle": {

&#x20;                                 "styleName": "title\_small"

&#x20;                               }

&#x20;                             },

&#x20;                             "font\_weight": {

&#x20;                               "stringVal": {

&#x20;                                 "value": "bold"

&#x20;                               }

&#x20;                             }

&#x20;                           },

&#x20;                           "editorId": "text111"

&#x20;                         },

&#x20;                         {

&#x20;                           "type": "row",

&#x20;                           "properties": {

&#x20;                             "spacing": {

&#x20;                               "stringVal": {

&#x20;                                 "value": "md"

&#x20;                               }

&#x20;                             }

&#x20;                           },

&#x20;                           "children": \[

&#x20;                             {

&#x20;                               "type": "expanded",

&#x20;                               "children": \[

&#x20;                                 {

&#x20;                                   "type": "@macro\_row",

&#x20;                                   "properties": {

&#x20;                                     "label": {

&#x20;                                       "stringVal": {

&#x20;                                         "value": "Protein"

&#x20;                                       }

&#x20;                                     },

&#x20;                                     "amount": {

&#x20;                                       "stringVal": {

&#x20;                                         "value": "92/150g"

&#x20;                                       }

&#x20;                                     },

&#x20;                                     "value": {

&#x20;                                       "numberVal": {

&#x20;                                         "value": 0.61

&#x20;                                       }

&#x20;                                     },

&#x20;                                     "tone": {

&#x20;                                       "stringVal": {

&#x20;                                         "value": "primary"

&#x20;                                       }

&#x20;                                     }

&#x20;                                   },

&#x20;                                   "editorId": "macrorow1"

&#x20;                                 }

&#x20;                               ],

&#x20;                               "editorId": "expanded24"

&#x20;                             },

&#x20;                             {

&#x20;                               "type": "expanded",

&#x20;                               "children": \[

&#x20;                                 {

&#x20;                                   "type": "@macro\_row",

&#x20;                                   "properties": {

&#x20;                                     "label": {

&#x20;                                       "stringVal": {

&#x20;                                         "value": "Carbs"

&#x20;                                       }

&#x20;                                     },

&#x20;                                     "amount": {

&#x20;                                       "stringVal": {

&#x20;                                         "value": "180/250g"

&#x20;                                       }

&#x20;                                     },

&#x20;                                     "value": {

&#x20;                                       "numberVal": {

&#x20;                                         "value": 0.72

&#x20;                                       }

&#x20;                                     },

&#x20;                                     "tone": {

&#x20;                                       "stringVal": {

&#x20;                                         "value": "accent"

&#x20;                                       }

&#x20;                                     }

&#x20;                                   },

&#x20;                                   "editorId": "macrorow2"

&#x20;                                 }

&#x20;                               ],

&#x20;                               "editorId": "expanded25"

&#x20;                             },

&#x20;                             {

&#x20;                               "type": "expanded",

&#x20;                               "children": \[

&#x20;                                 {

&#x20;                                   "type": "@macro\_row",

&#x20;                                   "properties": {

&#x20;                                     "label": {

&#x20;                                       "stringVal": {

&#x20;                                         "value": "Fat"

&#x20;                                       }

&#x20;                                     },

&#x20;                                     "amount": {

&#x20;                                       "stringVal": {

&#x20;                                         "value": "45/70g"

&#x20;                                       }

&#x20;                                     },

&#x20;                                     "value": {

&#x20;                                       "numberVal": {

&#x20;                                         "value": 0.64

&#x20;                                       }

&#x20;                                     },

&#x20;                                     "tone": {

&#x20;                                       "stringVal": {

&#x20;                                         "value": "warning"

&#x20;                                       }

&#x20;                                     }

&#x20;                                   },

&#x20;                                   "editorId": "macrorow3"

&#x20;                                 }

&#x20;                               ],

&#x20;                               "editorId": "expanded5"

&#x20;                             }

&#x20;                           ],

&#x20;                           "editorId": "row63"

&#x20;                         }

&#x20;                       ],

&#x20;                       "editorId": "column81"

&#x20;                     }

&#x20;                   ],

&#x20;                   "editorId": "container94"

&#x20;                 },

&#x20;                 {

&#x20;                   "type": "column",

&#x20;                   "properties": {

&#x20;                     "spacing": {

&#x20;                       "stringVal": {

&#x20;                         "value": "md"

&#x20;                       }

&#x20;                     },

&#x20;                     "cross\_align": {

&#x20;                       "align": {

&#x20;                         "named": "stretch"

&#x20;                       }

&#x20;                     }

&#x20;                   },

&#x20;                   "children": \[

&#x20;                     {

&#x20;                       "type": "text",

&#x20;                       "properties": {

&#x20;                         "content": {

&#x20;                           "stringVal": {

&#x20;                             "value": "Meals"

&#x20;                           }

&#x20;                         },

&#x20;                         "style": {

&#x20;                           "textStyle": {

&#x20;                             "styleName": "title\_medium"

&#x20;                           }

&#x20;                         },

&#x20;                         "font\_weight": {

&#x20;                           "stringVal": {

&#x20;                             "value": "bold"

&#x20;                           }

&#x20;                         }

&#x20;                       },

&#x20;                       "editorId": "text112"

&#x20;                     },

&#x20;                     {

&#x20;                       "type": "@meal\_section",

&#x20;                       "properties": {

&#x20;                         "title": {

&#x20;                           "stringVal": {

&#x20;                             "value": "Breakfast"

&#x20;                           }

&#x20;                         },

&#x20;                         "foods": {

&#x20;                           "stringVal": {

&#x20;                             "value": "Greek Yogurt, Blueberries, Granola"

&#x20;                           }

&#x20;                         },

&#x20;                         "cals": {

&#x20;                           "stringVal": {

&#x20;                             "value": "340"

&#x20;                           }

&#x20;                         },

&#x20;                         "icon": {

&#x20;                           "stringVal": {

&#x20;                             "value": "breakfast\_dining\_rounded"

&#x20;                           }

&#x20;                         }

&#x20;                       },

&#x20;                       "editorId": "mealsection1"

&#x20;                     },

&#x20;                     {

&#x20;                       "type": "@meal\_section",

&#x20;                       "properties": {

&#x20;                         "title": {

&#x20;                           "stringVal": {

&#x20;                             "value": "Lunch"

&#x20;                           }

&#x20;                         },

&#x20;                         "foods": {

&#x20;                           "stringVal": {

&#x20;                             "value": "Quinoa Salad, Grilled Chicken Breast"

&#x20;                           }

&#x20;                         },

&#x20;                         "cals": {

&#x20;                           "stringVal": {

&#x20;                             "value": "580"

&#x20;                           }

&#x20;                         },

&#x20;                         "icon": {

&#x20;                           "stringVal": {

&#x20;                             "value": "lunch\_dining\_rounded"

&#x20;                           }

&#x20;                         }

&#x20;                       },

&#x20;                       "editorId": "mealsection2"

&#x20;                     },

&#x20;                     {

&#x20;                       "type": "@meal\_section",

&#x20;                       "properties": {

&#x20;                         "title": {

&#x20;                           "stringVal": {

&#x20;                             "value": "Dinner"

&#x20;                           }

&#x20;                         },

&#x20;                         "foods": {

&#x20;                           "stringVal": {

&#x20;                             "value": "Grilled Salmon, Roasted Asparagus"

&#x20;                           }

&#x20;                         },

&#x20;                         "cals": {

&#x20;                           "stringVal": {

&#x20;                             "value": "500"

&#x20;                           }

&#x20;                         },

&#x20;                         "icon": {

&#x20;                           "stringVal": {

&#x20;                             "value": "restaurant\_rounded"

&#x20;                           }

&#x20;                         }

&#x20;                       },

&#x20;                       "editorId": "mealsection3"

&#x20;                     },

&#x20;                     {

&#x20;                       "type": "@meal\_section",

&#x20;                       "properties": {

&#x20;                         "title": {

&#x20;                           "stringVal": {

&#x20;                             "value": "Snacks"

&#x20;                           }

&#x20;                         },

&#x20;                         "foods": {

&#x20;                           "stringVal": {

&#x20;                             "value": "Handful of Almonds"

&#x20;                           }

&#x20;                         },

&#x20;                         "cals": {

&#x20;                           "stringVal": {

&#x20;                             "value": "120"

&#x20;                           }

&#x20;                         },

&#x20;                         "icon": {

&#x20;                           "stringVal": {

&#x20;                             "value": "cookie\_rounded"

&#x20;                           }

&#x20;                         }

&#x20;                       },

&#x20;                       "editorId": "mealsection4"

&#x20;                     }

&#x20;                   ],

&#x20;                   "editorId": "column82"

&#x20;                 }

&#x20;               ],

&#x20;               "editorId": "column79"

&#x20;             }

&#x20;           ],

&#x20;           "editorId": "expanded22"

&#x20;         },

&#x20;         {

&#x20;           "type": "container",

&#x20;           "properties": {

&#x20;             "align": {

&#x20;               "align": {

&#x20;                 "named": "bottom"

&#x20;               }

&#x20;             }

&#x20;           },

&#x20;           "children": \[

&#x20;             {

&#x20;               "type": "@std.bottom\_nav",

&#x20;               "children": \[

&#x20;                 {

&#x20;                   "type": "@std.nav\_item",

&#x20;                   "properties": {

&#x20;                     "target": {

&#x20;                       "stringVal": {

&#x20;                         "value": "dashboard"

&#x20;                       }

&#x20;                     },

&#x20;                     "label": {

&#x20;                       "stringVal": {

&#x20;                         "value": "Dashboard"

&#x20;                       }

&#x20;                     },

&#x20;                     "icon": {

&#x20;                       "stringVal": {

&#x20;                         "value": "dashboard\_rounded"

&#x20;                       }

&#x20;                     }

&#x20;                   },

&#x20;                   "editorId": "stdnavitem1"

&#x20;                 },

&#x20;                 {

&#x20;                   "type": "@std.nav\_item",

&#x20;                   "properties": {

&#x20;                     "target": {

&#x20;                       "stringVal": {

&#x20;                         "value": "categories"

&#x20;                       }

&#x20;                     },

&#x20;                     "label": {

&#x20;                       "stringVal": {

&#x20;                         "value": "Categories"

&#x20;                       }

&#x20;                     },

&#x20;                     "icon": {

&#x20;                       "stringVal": {

&#x20;                         "value": "category\_rounded"

&#x20;                       }

&#x20;                     }

&#x20;                   },

&#x20;                   "editorId": "stdnavitem2"

&#x20;                 },

&#x20;                 {

&#x20;                   "type": "@std.nav\_item",

&#x20;                   "properties": {

&#x20;                     "target": {

&#x20;                       "stringVal": {

&#x20;                         "value": "analytics"

&#x20;                       }

&#x20;                     },

&#x20;                     "label": {

&#x20;                       "stringVal": {

&#x20;                         "value": "Analytics"

&#x20;                       }

&#x20;                     },

&#x20;                     "icon": {

&#x20;                       "stringVal": {

&#x20;                         "value": "insights\_rounded"

&#x20;                       }

&#x20;                     },

&#x20;                     "selected": {

&#x20;                       "boolVal": {

&#x20;                         "value": true

&#x20;                       }

&#x20;                     }

&#x20;                   },

&#x20;                   "editorId": "stdnavitem3"

&#x20;                 },

&#x20;                 {

&#x20;                   "type": "@std.nav\_item",

&#x20;                   "properties": {

&#x20;                     "target": {

&#x20;                       "stringVal": {

&#x20;                         "value": "settings"

&#x20;                       }

&#x20;                     },

&#x20;                     "label": {

&#x20;                       "stringVal": {

&#x20;                         "value": "Settings"

&#x20;                       }

&#x20;                     },

&#x20;                     "icon": {

&#x20;                       "stringVal": {

&#x20;                         "value": "settings\_rounded"

&#x20;                       }

&#x20;                     }

&#x20;                   },

&#x20;                   "editorId": "stdnavitem4"

&#x20;                 }

&#x20;               ],

&#x20;               "editorId": "stdbottomnav1"

&#x20;             }

&#x20;           ],

&#x20;           "editorId": "container95"

&#x20;         }

&#x20;       ],

&#x20;       "editorId": "column77"

&#x20;     }

&#x20;   ],

&#x20;   "editorId": "scaffold8"

&#x20; }

}

```



\### 9. App Settings



\- Frame ID: `frame3`

\- Original page prompt: "Configuration for dark mode, week start day, and local data export/import tools."

\- Follow-up prompts: \_None\_



\#### DslDocument (JSON)



```json

{

&#x20; "root": {

&#x20;   "type": "scaffold",

&#x20;   "properties": {

&#x20;     "bg": {

&#x20;       "color": {

&#x20;         "color": "background"

&#x20;       }

&#x20;     }

&#x20;   },

&#x20;   "children": \[

&#x20;     {

&#x20;       "type": "column",

&#x20;       "properties": {

&#x20;         "scroll": {

&#x20;           "boolVal": {

&#x20;             "value": true

&#x20;           }

&#x20;         },

&#x20;         "padding": {

&#x20;           "edgeInsets": {

&#x20;             "top": 0,

&#x20;             "right": 0,

&#x20;             "bottom": 0,

&#x20;             "left": 0,

&#x20;             "token": "lg"

&#x20;           }

&#x20;         },

&#x20;         "spacing": {

&#x20;           "stringVal": {

&#x20;             "value": "lg"

&#x20;           }

&#x20;         }

&#x20;       },

&#x20;       "children": \[

&#x20;         {

&#x20;           "type": "row",

&#x20;           "properties": {

&#x20;             "align": {

&#x20;               "align": {

&#x20;                 "named": "space\_between"

&#x20;               }

&#x20;             }

&#x20;           },

&#x20;           "children": \[

&#x20;             {

&#x20;               "type": "column",

&#x20;               "properties": {

&#x20;                 "cross\_align": {

&#x20;                   "align": {

&#x20;                     "named": "start"

&#x20;                   }

&#x20;                 },

&#x20;                 "spacing": {

&#x20;                   "stringVal": {

&#x20;                     "value": "xs"

&#x20;                   }

&#x20;                 }

&#x20;               },

&#x20;               "children": \[

&#x20;                 {

&#x20;                   "type": "text",

&#x20;                   "properties": {

&#x20;                     "content": {

&#x20;                       "stringVal": {

&#x20;                         "value": "Settings"

&#x20;                       }

&#x20;                     },

&#x20;                     "style": {

&#x20;                       "textStyle": {

&#x20;                         "styleName": "headline\_medium"

&#x20;                       }

&#x20;                     },

&#x20;                     "color": {

&#x20;                       "color": {

&#x20;                         "color": "primary\_text"

&#x20;                       }

&#x20;                     },

&#x20;                     "font\_weight": {

&#x20;                       "stringVal": {

&#x20;                         "value": "bold"

&#x20;                       }

&#x20;                     }

&#x20;                   },

&#x20;                   "editorId": "text113"

&#x20;                 },

&#x20;                 {

&#x20;                   "type": "text",

&#x20;                   "properties": {

&#x20;                     "content": {

&#x20;                       "stringVal": {

&#x20;                         "value": "Manage your offline preferences"

&#x20;                       }

&#x20;                     },

&#x20;                     "style": {

&#x20;                       "textStyle": {

&#x20;                         "styleName": "body\_medium"

&#x20;                       }

&#x20;                     },

&#x20;                     "color": {

&#x20;                       "color": {

&#x20;                         "color": "secondary\_text"

&#x20;                       }

&#x20;                     }

&#x20;                   },

&#x20;                   "editorId": "text114"

&#x20;                 }

&#x20;               ],

&#x20;               "editorId": "column84"

&#x20;             },

&#x20;             {

&#x20;               "type": "iconbutton",

&#x20;               "properties": {

&#x20;                 "name": {

&#x20;                   "icon": {

&#x20;                     "name": "close\_rounded"

&#x20;                   }

&#x20;                 },

&#x20;                 "color": {

&#x20;                   "color": {

&#x20;                     "color": "secondary\_text"

&#x20;                   }

&#x20;                 },

&#x20;                 "bg": {

&#x20;                   "color": {

&#x20;                     "color": "surface"

&#x20;                   }

&#x20;                 },

&#x20;                 "radius": {

&#x20;                   "radius": {

&#x20;                     "topLeft": 0,

&#x20;                     "topRight": 0,

&#x20;                     "bottomLeft": 0,

&#x20;                     "bottomRight": 0,

&#x20;                     "token": "full"

&#x20;                   }

&#x20;                 },

&#x20;                 "on\_tap": {

&#x20;                   "stringVal": {

&#x20;                     "value": "navigate:Dashboard"

&#x20;                   }

&#x20;                 }

&#x20;               },

&#x20;               "editorId": "iconbutton16"

&#x20;             }

&#x20;           ],

&#x20;           "editorId": "row64"

&#x20;         },

&#x20;         {

&#x20;           "type": "@settings\_group",

&#x20;           "properties": {

&#x20;             "title": {

&#x20;               "stringVal": {

&#x20;                 "value": "APPEARANCE"

&#x20;               }

&#x20;             }

&#x20;           },

&#x20;           "children": \[

&#x20;             {

&#x20;               "type": "@settings\_item",

&#x20;               "properties": {

&#x20;                 "icon": {

&#x20;                   "stringVal": {

&#x20;                     "value": "dark\_mode\_rounded"

&#x20;                   }

&#x20;                 },

&#x20;                 "label": {

&#x20;                   "stringVal": {

&#x20;                     "value": "Dark Mode"

&#x20;                   }

&#x20;                 },

&#x20;                 "sub": {

&#x20;                   "stringVal": {

&#x20;                     "value": "Adjust app theme"

&#x20;                   }

&#x20;                 }

&#x20;               },

&#x20;               "children": \[

&#x20;                 {

&#x20;                   "type": "@std.tab\_group",

&#x20;                   "properties": {

&#x20;                     "label\_1": {

&#x20;                       "stringVal": {

&#x20;                         "value": "Light"

&#x20;                       }

&#x20;                     },

&#x20;                     "label\_2": {

&#x20;                       "stringVal": {

&#x20;                         "value": "Dark"

&#x20;                       }

&#x20;                     },

&#x20;                     "label\_3": {

&#x20;                       "stringVal": {

&#x20;                         "value": "System"

&#x20;                       }

&#x20;                     }

&#x20;                   },

&#x20;                   "editorId": "stdtabgroup2"

&#x20;                 }

&#x20;               ],

&#x20;               "editorId": "settingsitem1"

&#x20;             },

&#x20;             {

&#x20;               "type": "@settings\_item",

&#x20;               "properties": {

&#x20;                 "icon": {

&#x20;                   "stringVal": {

&#x20;                     "value": "palette\_rounded"

&#x20;                   }

&#x20;                 },

&#x20;                 "label": {

&#x20;                   "stringVal": {

&#x20;                     "value": "Accent Color"

&#x20;                   }

&#x20;                 },

&#x20;                 "sub": {

&#x20;                   "stringVal": {

&#x20;                     "value": "Calm Teal"

&#x20;                   }

&#x20;                 },

&#x20;                 "last": {

&#x20;                   "boolVal": {

&#x20;                     "value": true

&#x20;                   }

&#x20;                 }

&#x20;               },

&#x20;               "children": \[

&#x20;                 {

&#x20;                   "type": "container",

&#x20;                   "properties": {

&#x20;                     "width": {

&#x20;                       "px": {

&#x20;                         "value": 24,

&#x20;                         "isInfinity": false

&#x20;                       }

&#x20;                     },

&#x20;                     "height": {

&#x20;                       "px": {

&#x20;                         "value": 24,

&#x20;                         "isInfinity": false

&#x20;                       }

&#x20;                     },

&#x20;                     "radius": {

&#x20;                       "radius": {

&#x20;                         "topLeft": 0,

&#x20;                         "topRight": 0,

&#x20;                         "bottomLeft": 0,

&#x20;                         "bottomRight": 0,

&#x20;                         "token": "full"

&#x20;                       }

&#x20;                     },

&#x20;                     "bg": {

&#x20;                       "color": {

&#x20;                         "color": "#4DB6AC"

&#x20;                       }

&#x20;                     }

&#x20;                   },

&#x20;                   "editorId": "container96"

&#x20;                 }

&#x20;               ],

&#x20;               "editorId": "settingsitem2"

&#x20;             }

&#x20;           ],

&#x20;           "editorId": "settingsgroup1"

&#x20;         },

&#x20;         {

&#x20;           "type": "@settings\_group",

&#x20;           "properties": {

&#x20;             "title": {

&#x20;               "stringVal": {

&#x20;                 "value": "PREFERENCES"

&#x20;               }

&#x20;             }

&#x20;           },

&#x20;           "children": \[

&#x20;             {

&#x20;               "type": "@settings\_item",

&#x20;               "properties": {

&#x20;                 "icon": {

&#x20;                   "stringVal": {

&#x20;                     "value": "calendar\_today\_rounded"

&#x20;                   }

&#x20;                 },

&#x20;                 "label": {

&#x20;                   "stringVal": {

&#x20;                     "value": "Week Start Day"

&#x20;                   }

&#x20;                 },

&#x20;                 "sub": {

&#x20;                   "stringVal": {

&#x20;                     "value": "Monday"

&#x20;                   }

&#x20;                 }

&#x20;               },

&#x20;               "children": \[

&#x20;                 {

&#x20;                   "type": "icon",

&#x20;                   "properties": {

&#x20;                     "name": {

&#x20;                       "icon": {

&#x20;                         "name": "chevron\_right\_rounded"

&#x20;                       }

&#x20;                     },

&#x20;                     "color": {

&#x20;                       "color": {

&#x20;                         "color": "on\_surface"

&#x20;                       }

&#x20;                     }

&#x20;                   },

&#x20;                   "editorId": "icon37"

&#x20;                 }

&#x20;               ],

&#x20;               "editorId": "settingsitem3"

&#x20;             },

&#x20;             {

&#x20;               "type": "@settings\_item",

&#x20;               "properties": {

&#x20;                 "icon": {

&#x20;                   "stringVal": {

&#x20;                     "value": "notifications\_active\_rounded"

&#x20;                   }

&#x20;                 },

&#x20;                 "label": {

&#x20;                   "stringVal": {

&#x20;                     "value": "Default Reminders"

&#x20;                   }

&#x20;                 },

&#x20;                 "sub": {

&#x20;                   "stringVal": {

&#x20;                     "value": "08:00 AM"

&#x20;                   }

&#x20;                 }

&#x20;               },

&#x20;               "children": \[

&#x20;                 {

&#x20;                   "type": "icon",

&#x20;                   "properties": {

&#x20;                     "name": {

&#x20;                       "icon": {

&#x20;                         "name": "chevron\_right\_rounded"

&#x20;                       }

&#x20;                     },

&#x20;                     "color": {

&#x20;                       "color": {

&#x20;                         "color": "on\_surface"

&#x20;                       }

&#x20;                     }

&#x20;                   },

&#x20;                   "editorId": "icon38"

&#x20;                 }

&#x20;               ],

&#x20;               "editorId": "settingsitem4"

&#x20;             },

&#x20;             {

&#x20;               "type": "@settings\_item",

&#x20;               "properties": {

&#x20;                 "icon": {

&#x20;                   "stringVal": {

&#x20;                     "value": "timer\_rounded"

&#x20;                   }

&#x20;                 },

&#x20;                 "label": {

&#x20;                   "stringVal": {

&#x20;                     "value": "24-Hour Time"

&#x20;                   }

&#x20;                 },

&#x20;                 "last": {

&#x20;                   "boolVal": {

&#x20;                     "value": true

&#x20;                   }

&#x20;                 }

&#x20;               },

&#x20;               "children": \[

&#x20;                 {

&#x20;                   "type": "@std.switch",

&#x20;                   "properties": {

&#x20;                     "active": {

&#x20;                       "boolVal": {

&#x20;                         "value": true

&#x20;                       }

&#x20;                     }

&#x20;                   },

&#x20;                   "editorId": "stdswitch3"

&#x20;                 }

&#x20;               ],

&#x20;               "editorId": "settingsitem5"

&#x20;             }

&#x20;           ],

&#x20;           "editorId": "settingsgroup2"

&#x20;         },

&#x20;         {

&#x20;           "type": "@settings\_group",

&#x20;           "properties": {

&#x20;             "title": {

&#x20;               "stringVal": {

&#x20;                 "value": "DATA \& PRIVACY"

&#x20;               }

&#x20;             }

&#x20;           },

&#x20;           "children": \[

&#x20;             {

&#x20;               "type": "@settings\_item",

&#x20;               "properties": {

&#x20;                 "icon": {

&#x20;                   "stringVal": {

&#x20;                     "value": "download\_rounded"

&#x20;                   }

&#x20;                 },

&#x20;                 "label": {

&#x20;                   "stringVal": {

&#x20;                     "value": "Export Data"

&#x20;                   }

&#x20;                 },

&#x20;                 "sub": {

&#x20;                   "stringVal": {

&#x20;                     "value": "Save JSON/CSV to device"

&#x20;                   }

&#x20;                 }

&#x20;               },

&#x20;               "children": \[

&#x20;                 {

&#x20;                   "type": "icon",

&#x20;                   "properties": {

&#x20;                     "name": {

&#x20;                       "icon": {

&#x20;                         "name": "file\_download\_outlined"

&#x20;                       }

&#x20;                     },

&#x20;                     "color": {

&#x20;                       "color": {

&#x20;                         "color": "primary"

&#x20;                       }

&#x20;                     }

&#x20;                   },

&#x20;                   "editorId": "icon39"

&#x20;                 }

&#x20;               ],

&#x20;               "editorId": "settingsitem6"

&#x20;             },

&#x20;             {

&#x20;               "type": "@settings\_item",

&#x20;               "properties": {

&#x20;                 "icon": {

&#x20;                   "stringVal": {

&#x20;                     "value": "upload\_rounded"

&#x20;                   }

&#x20;                 },

&#x20;                 "label": {

&#x20;                   "stringVal": {

&#x20;                     "value": "Import Data"

&#x20;                   }

&#x20;                 },

&#x20;                 "sub": {

&#x20;                   "stringVal": {

&#x20;                     "value": "Restore from local file"

&#x20;                   }

&#x20;                 }

&#x20;               },

&#x20;               "children": \[

&#x20;                 {

&#x20;                   "type": "icon",

&#x20;                   "properties": {

&#x20;                     "name": {

&#x20;                       "icon": {

&#x20;                         "name": "file\_upload\_outlined"

&#x20;                       }

&#x20;                     },

&#x20;                     "color": {

&#x20;                       "color": {

&#x20;                         "color": "primary"

&#x20;                       }

&#x20;                     }

&#x20;                   },

&#x20;                   "editorId": "icon40"

&#x20;                 }

&#x20;               ],

&#x20;               "editorId": "settingsitem7"

&#x20;             },

&#x20;             {

&#x20;               "type": "@settings\_item",

&#x20;               "properties": {

&#x20;                 "icon": {

&#x20;                   "stringVal": {

&#x20;                     "value": "delete\_forever\_rounded"

&#x20;                   }

&#x20;                 },

&#x20;                 "label": {

&#x20;                   "stringVal": {

&#x20;                     "value": "Clear All Data"

&#x20;                   }

&#x20;                 },

&#x20;                 "sub": {

&#x20;                   "stringVal": {

&#x20;                     "value": "Permanently delete all logs"

&#x20;                   }

&#x20;                 },

&#x20;                 "last": {

&#x20;                   "boolVal": {

&#x20;                     "value": true

&#x20;                   }

&#x20;                 }

&#x20;               },

&#x20;               "children": \[

&#x20;                 {

&#x20;                   "type": "icon",

&#x20;                   "properties": {

&#x20;                     "name": {

&#x20;                       "icon": {

&#x20;                         "name": "warning\_amber\_rounded"

&#x20;                       }

&#x20;                     },

&#x20;                     "color": {

&#x20;                       "color": {

&#x20;                         "color": "error"

&#x20;                       }

&#x20;                     }

&#x20;                   },

&#x20;                   "editorId": "icon41"

&#x20;                 }

&#x20;               ],

&#x20;               "editorId": "settingsitem8"

&#x20;             }

&#x20;           ],

&#x20;           "editorId": "settingsgroup3"

&#x20;         },

&#x20;         {

&#x20;           "type": "@settings\_group",

&#x20;           "properties": {

&#x20;             "title": {

&#x20;               "stringVal": {

&#x20;                 "value": "ABOUT"

&#x20;               }

&#x20;             }

&#x20;           },

&#x20;           "children": \[

&#x20;             {

&#x20;               "type": "@settings\_item",

&#x20;               "properties": {

&#x20;                 "icon": {

&#x20;                   "stringVal": {

&#x20;                     "value": "info\_outline\_rounded"

&#x20;                   }

&#x20;                 },

&#x20;                 "label": {

&#x20;                   "stringVal": {

&#x20;                     "value": "Version"

&#x20;                   }

&#x20;                 },

&#x20;                 "sub": {

&#x20;                   "stringVal": {

&#x20;                     "value": "1.2.0 (Build 42)"

&#x20;                   }

&#x20;                 }

&#x20;               },

&#x20;               "editorId": "settingsitem9"

&#x20;             },

&#x20;             {

&#x20;               "type": "@settings\_item",

&#x20;               "properties": {

&#x20;                 "icon": {

&#x20;                   "stringVal": {

&#x20;                     "value": "description\_outlined"

&#x20;                   }

&#x20;                 },

&#x20;                 "label": {

&#x20;                   "stringVal": {

&#x20;                     "value": "Privacy Policy"

&#x20;                   }

&#x20;                 },

&#x20;                 "last": {

&#x20;                   "boolVal": {

&#x20;                     "value": true

&#x20;                   }

&#x20;                 }

&#x20;               },

&#x20;               "children": \[

&#x20;                 {

&#x20;                   "type": "icon",

&#x20;                   "properties": {

&#x20;                     "name": {

&#x20;                       "icon": {

&#x20;                         "name": "open\_in\_new\_rounded"

&#x20;                       }

&#x20;                     },

&#x20;                     "size": {

&#x20;                       "numberVal": {

&#x20;                         "value": 18

&#x20;                       }

&#x20;                     },

&#x20;                     "color": {

&#x20;                       "color": {

&#x20;                         "color": "on\_surface"

&#x20;                       }

&#x20;                     }

&#x20;                   },

&#x20;                   "editorId": "icon42"

&#x20;                 }

&#x20;               ],

&#x20;               "editorId": "settingsitem10"

&#x20;             }

&#x20;           ],

&#x20;           "editorId": "settingsgroup4"

&#x20;         },

&#x20;         {

&#x20;           "type": "container",

&#x20;           "properties": {

&#x20;             "padding": {

&#x20;               "edgeInsets": {

&#x20;                 "top": 0,

&#x20;                 "right": 0,

&#x20;                 "bottom": 0,

&#x20;                 "left": 0,

&#x20;                 "token": "lg"

&#x20;               }

&#x20;             },

&#x20;             "align\_child": {

&#x20;               "align": {

&#x20;                 "named": "center"

&#x20;               }

&#x20;             }

&#x20;           },

&#x20;           "children": \[

&#x20;             {

&#x20;               "type": "column",

&#x20;               "properties": {

&#x20;                 "spacing": {

&#x20;                   "stringVal": {

&#x20;                     "value": "xs"

&#x20;                   }

&#x20;                 }

&#x20;               },

&#x20;               "children": \[

&#x20;                 {

&#x20;                   "type": "text",

&#x20;                   "properties": {

&#x20;                     "content": {

&#x20;                       "stringVal": {

&#x20;                         "value": "Life Tracker"

&#x20;                       }

&#x20;                     },

&#x20;                     "style": {

&#x20;                       "textStyle": {

&#x20;                         "styleName": "title\_small"

&#x20;                       }

&#x20;                     },

&#x20;                     "color": {

&#x20;                       "color": {

&#x20;                         "color": "secondary\_text"

&#x20;                       }

&#x20;                     },

&#x20;                     "font\_weight": {

&#x20;                       "stringVal": {

&#x20;                         "value": "bold"

&#x20;                       }

&#x20;                     }

&#x20;                   },

&#x20;                   "editorId": "text115"

&#x20;                 },

&#x20;                 {

&#x20;                   "type": "text",

&#x20;                   "properties": {

&#x20;                     "content": {

&#x20;                       "stringVal": {

&#x20;                         "value": "Fully Offline \& Private"

&#x20;                       }

&#x20;                     },

&#x20;                     "style": {

&#x20;                       "textStyle": {

&#x20;                         "styleName": "label\_small"

&#x20;                       }

&#x20;                     },

&#x20;                     "color": {

&#x20;                       "color": {

&#x20;                         "color": "on\_surface"

&#x20;                       }

&#x20;                     }

&#x20;                   },

&#x20;                   "editorId": "text116"

&#x20;                 }

&#x20;               ],

&#x20;               "editorId": "column85"

&#x20;             }

&#x20;           ],

&#x20;           "editorId": "container97"

&#x20;         },

&#x20;         {

&#x20;           "type": "sizedbox",

&#x20;           "properties": {

&#x20;             "height": {

&#x20;               "stringVal": {

&#x20;                 "value": "xl"

&#x20;               }

&#x20;             }

&#x20;           },

&#x20;           "editorId": "sizedbox7"

&#x20;         }

&#x20;       ],

&#x20;       "editorId": "column83"

&#x20;     }

&#x20;   ],

&#x20;   "editorId": "scaffold9"

&#x20; }

}

```

