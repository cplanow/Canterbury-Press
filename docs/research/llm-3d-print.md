# LLM-3D Print (CMU / Barati Lab) — Research Report

**Date:** March 2026
**Relevance to Canterbury Press:** High (future integration project)

---

## Paper Details

| Attribute | Detail |
|-----------|--------|
| **Full Title** | "LLM-3D Print: Large Language Models To Monitor and Control 3D Printing" |
| **Authors** | Yayati Jadhav, Peter Pak, Amir Barati Farimani |
| **Affiliation** | Department of Mechanical Engineering, Carnegie Mellon University |
| **arXiv** | [2408.14307](https://arxiv.org/abs/2408.14307) (submitted Aug 26, 2024; v3 Sep 27, 2025) |
| **Published** | *Additive Manufacturing*, Vol. 114, September 2025, Article 105027 |
| **DOI** | [10.1016/j.addma.2025.105027](https://doi.org/10.1016/j.addma.2025.105027) |
| **ScienceDirect** | [Published version](https://www.sciencedirect.com/science/article/pii/S2214860425003926) |
| **Project Website** | [PrinterChat (CMU)](https://sites.google.com/andrew.cmu.edu/printerchat) |
| **GitHub** | [BaratiLab/LLM-3D-Print](https://github.com/BaratiLab/LLM-3D-Print-Large-Language-Models-To-Monitor-and-Control-3D-Printing) |
| **CMU News** | [AI Saves 3D Prints](https://engineering.cmu.edu/news-events/news/2026/02/06-ai-saves-3d-prints.html) |

---

## Overview

LLM-3D Print is a process monitoring and control framework that uses pre-trained Large Language Models to **autonomously detect, diagnose, and correct 3D printing defects in real time**, without human intervention.

### Problem Statement

Fused Deposition Modeling (FDM) 3D printing is plagued by defects (stringing, warping, under-extrusion, poor layer adhesion, etc.) that traditionally require either:
- Constant expert supervision, or
- Extensive labeled datasets for machine learning approaches

LLM-3D Print eliminates both requirements by leveraging the pre-existing knowledge embedded in foundation LLMs, combined with a multi-agent architecture that reasons about defects, queries the printer, and applies corrections autonomously.

### Key Result

**5.06x increase in peak load capacity** for parts manufactured with LLM corrections, with significantly enhanced structural integrity. When benchmarked against **14 additive manufacturing experts**, the LLM matched or exceeded their accuracy in identifying major failure modes and was able to recognize emerging errors **earlier** than human experts.

---

## Architecture: Multi-Agent LLM System

The framework uses a hierarchical multi-agent architecture with **four specialized LLM agents** coordinated by a **supervisory agent**. The supervisory agent maintains a "dynamic state dictionary" accessible to all modules and orchestrates activation timing.

### The Four Agents

| Agent | Role | Details |
|-------|------|---------|
| **Error Detection Agent** | Analyzes captured camera images using vision-language model capabilities to identify defects and assess print quality | Uses GPT-4o multimodal vision |
| **Information Planning Agent** | Formulates plans for gathering diagnostic data from the printer (what parameters to query) | Determines which printer state variables are relevant to the detected issue |
| **Solution Planning Agent** | Develops corrective action strategies based on identified issues and gathered diagnostic data | Reasons about root causes and generates parameter adjustment plans |
| **Executor Agent** | Implements corrective plans by translating them into API calls and G-code commands using the ReAct method; monitors responses and adjusts dynamically | Interfaces directly with printer firmware |

The **Supervisor Agent** acts as an orchestrator (described as a "maestro" coordinating "specialized sections"), managing module sequencing, ensuring smooth transitions between stages, and maintaining shared state across all agents.

### Per-Layer Feedback Loop

```
┌─────────────────────────────────────────────────────────────┐
│ 1. Print completes a layer                                  │
│ 2. Extruder returns to home position                        │
│ 3. Two cameras capture top-view and front-view images       │
│ 4. Error Detection Agent analyzes images via GPT-4o vision  │
│ 5. If defects detected → Supervisor invokes Info Planning   │
│ 6. Executor queries printer state via Moonraker API         │
│ 7. Solution Planning Agent generates corrective actions     │
│ 8. Executor implements parameter adjustments via API        │
│ 9. Supervisor confirms changes, resumes print               │
│ 10. Process repeats with accumulated conversation history   │
└─────────────────────────────────────────────────────────────┘
```

The system uses **in-context learning**, **self-prompting**, and **iterative prompt-reason refinement** — the LLM improves its own decision-making logic over the course of a print, recognizing when prior corrections only partially improved quality and escalating adjustments accordingly.

---

## Technical Stack

### LLM Models
- **GPT-4o** (primary) — handles both text reasoning and multimodal image analysis
- **GPT-4.1** also evaluated to demonstrate robustness across model versions
- **No fine-tuning or custom training** — uses only base models with domain-specific structured prompts

### Software Dependencies
| Component | Version | Purpose |
|-----------|---------|---------|
| Python | 3.12.4 | Runtime |
| LangChain | 0.3.27 | Agent orchestration |
| LangGraph | 0.6.7 | Agent graph management |
| OpenAI API | — | LLM access |

### Printer Interface
| Component | Version | Purpose |
|-----------|---------|---------|
| **Klipper** | — | Firmware (reflashed onto test printers) |
| **Moonraker** | 0.9.3 | REST API for querying/modifying printer parameters |
| **Crowsnest** | 4.1.16 | Camera streaming plugin |
| **Mainsail** | 0.9.3 | Monitoring/control web interface |

### Camera Setup
- Two **SVPRO 1080P cameras** with 2.8-12mm manual focus range
- Top camera: captures in-situ layer images
- Front camera: provides side perspective
- Images captured while print is paused (extruder homed) to prevent toolhead interference

### Controllable Parameters
Print speed, flow rate, pressure advance, retraction settings, nozzle temperature, Z-offset, fan speed, acceleration.

**Important limitation:** The system **cannot modify slicer-generated G-code** (e.g., infill overlap percentage, toolpath geometry). It can only adjust runtime parameters during printing.

---

## Detectable and Correctable Errors

### Detected Defects
- Stringing / oozing
- Under-extrusion
- Over-extrusion
- Layer separation
- Warping
- Bed adhesion failures
- Nozzle clogs
- Inconsistent extrusion
- Material blobs / zits
- Poor layer adhesion

### Intentionally Ignored
- **Layer shift** — classified as "catastrophic" and uncorrectable without discarding the print

---

## Input / Output

### Inputs
- Two camera images (top + front view) captured after each layer
- Natural language part description
- Previous layer images (for deduplication / tracking changes)
- Real-time printer parameters queried via Moonraker API

### Outputs
- Structured defect identification and observations
- Root cause analysis
- Detailed manufacturing commentary and corrective action logs
- Modified runtime parameters via API calls
- Mechanically improved parts (validated through compression testing)

---

## Code Repository

**GitHub:** [BaratiLab/LLM-3D-Print-Large-Language-Models-To-Monitor-and-Control-3D-Printing](https://github.com/BaratiLab/LLM-3D-Print-Large-Language-Models-To-Monitor-and-Control-3D-Printing)

| Attribute | Detail |
|-----------|--------|
| **Language** | Python (100%) |
| **License** | Not specified |
| **Stars** | ~25 |
| **Forks** | ~3 |
| **Status** | "Code Updated Regularly" — under active development |

### Key Files
| File | Purpose |
|------|---------|
| `runner.py` | Main entry point |
| `chain.py` | LLM agent chain definitions |
| `tools.py` | Printer interface tools (Moonraker API calls) |
| `utils.py` | Utility functions |
| `snapshoter.py` | Camera image capture |
| `image_inference.py` | Image analysis pipeline |
| `printer_config/` | Klipper configuration files |
| `gcodes/` | Test G-code files |
| `prompts/` | LLM system prompts |

### Requirements
- Klipper firmware + Crowsnest + Moonraker on the target printer
- OpenAI API key (GPT-4o access)
- Python 3.12+ environment
- Two cameras positioned for top and front views

---

## Stated Limitations

1. **Processing latency:** 15-45 seconds per layer depending on failure complexity (significant for fast prints)
2. **Token context limits:** Firmware documentation must be summarized rather than provided in full
3. **Image resolution compression:** Images compressed to meet token constraints, reducing detection of fine details
4. **Misattribution of similar defects:** Occasionally confuses visually similar defects (e.g., blobs vs. stringing)
5. **No G-code modification:** Cannot correct defects embedded in the slicing phase (infill overlap, toolpath)
6. **Klipper-only:** Requires Klipper firmware with Moonraker API — not natively compatible with proprietary firmware
7. **API cost:** Requires OpenAI API access (GPT-4o) for every layer analysis
8. **Tested printers:** Only Creality Ender 5 Plus (with BLTouch) and Creality Ender 3 (without BLTouch)
9. **Tested materials:** Only PLA and TPU

---

## Bambu Lab P1S Integration Assessment

### The Core Challenge

LLM-3D Print requires **Klipper + Moonraker** for printer control. The Bambu Lab P1S runs **proprietary firmware** and cannot be reflashed to Klipper. However, the P1S does expose control capabilities through other means.

### What the P1S Offers

#### MQTT Protocol
The P1S has a local MQTT broker (port 8883, TLS) that supports:
- `print.pause` / `print.resume` — pause and resume prints
- `print.print_speed` — adjust print speed during operation
- `print.gcode_line` — send individual G-code commands
- `print.stop` — terminate prints
- Temperature, fan speed, and other telemetry monitoring
- Camera control and timelapse configuration

#### Python Libraries
- [bambulabs-api](https://pypi.org/project/bambulabs-api/) — Python MQTT interface for Bambu printers
- [OpenBambuAPI](https://github.com/Doridian/OpenBambuAPI) — community-documented MQTT protocol

#### Camera Access
Built-in camera accessible via RTSP/JPEG streaming; external cameras supported via OctoEverywhere's Bambu Connect.

#### LAN Only Mode
Required for full local MQTT control (recent firmware restricts some commands when connected to Bambu Cloud).

### Adaptation Feasibility Matrix

| LLM-3D Print Requirement | P1S Equivalent | Difficulty | Notes |
|---------------------------|----------------|------------|-------|
| Klipper Moonraker API | Bambu MQTT + `gcode_line` | **Medium** | Rewrite `tools.py` to use MQTT instead of REST |
| Camera capture (Crowsnest) | Built-in camera JPEG stream | **Low** | Rewrite `snapshoter.py` for RTSP/JPEG |
| Pause/resume print | MQTT `print.pause`/`print.resume` | **Low** | Direct equivalent |
| Modify nozzle temp, fan speed | G-code via `print.gcode_line` (M104, M106) | **Medium** | Possible but less clean than Moonraker |
| Modify flow rate / print speed | `print.print_speed` + G-code M220/M221 | **Medium** | Functional |
| Modify pressure advance / retraction | G-code commands | **High** | Bambu firmware may not support all Klipper-specific params |
| Layer-by-layer pause trigger | Insert pause G-code or monitor MQTT layer telemetry | **Medium-High** | Most complex adaptation piece |

### Estimated Effort

**2-4 weeks of development** for someone comfortable with Python, MQTT, and 3D printing. The main work items:

1. Replace Moonraker interface in `tools.py` with Bambu MQTT client
2. Replace `snapshoter.py` for P1S camera capture
3. Implement layer detection via MQTT telemetry monitoring
4. Adapt parameter mapping to Bambu-compatible G-code
5. Accept limitations on Klipper-specific parameters
6. Set printer to LAN Only Mode for full MQTT access

### Hybrid Approach (Recommended)

For immediate value, combine:
1. **Obico** for production-ready failure detection on the P1S (works today, free self-hosted)
2. **LLM-3D Print fork** adapted for Bambu MQTT as a longer-term project for autonomous correction

---

## Related Work in LLM-Assisted 3D Printing

| System | Description | Difference from LLM-3D Print |
|--------|-------------|-------------------------------|
| **[Obico](https://www.obico.io/)** | Open-source AI failure detection (YOLO-based CV). 89.8M+ hours monitored, 1M+ failures detected. | Detection only (pause/alert) — no autonomous correction |
| **[OctoEverywhere Gadget](https://octoeverywhere.com/)** | AI failure detection for OctoPrint, Klipper, and Bambu Lab printers | Detection + pause only — no corrective reasoning |
| **[Authentise 3DGPT](https://www.engineering.com/chatgpt-comes-for-3d-printing-with-authentises-3dgpt/)** | LLM trained on 12,000+ journal articles for AM Q&A | Advisory only — no real-time printer integration |
| **ChatGPT for AM** ([Brion & Pattinson, 2023](https://www.sciencedirect.com/science/article/pii/S2542504823000192)) | Early assessment of ChatGPT for 3D printing troubleshooting | Text-only advisory; no vision, no printer integration |
| **GLLM** ([arXiv 2501.17584](https://arxiv.org/abs/2501.17584)) | Self-corrective G-code generation from NL using fine-tuned StarCoder-3B + RAG | G-code generation, not runtime monitoring |
| **Slice-100K** ([arXiv 2407.04180](https://arxiv.org/html/2407.04180v3)) | Multimodal dataset for extrusion-based 3D printing | Dataset contribution, not active monitoring |

### What Makes LLM-3D Print Unique

LLM-3D Print is the **only published system** that combines all of:
- Multimodal vision-based defect detection
- Multi-agent LLM reasoning and diagnosis
- Autonomous real-time parameter correction
- No pre-training or custom datasets required
- Printer-agnostic design (in principle)

---

## Sources

- [LLM-3D Print on arXiv (2408.14307)](https://arxiv.org/abs/2408.14307)
- [LLM-3D Print Full HTML Paper (v3)](https://arxiv.org/html/2408.14307v3)
- [Published in Additive Manufacturing (ScienceDirect)](https://www.sciencedirect.com/science/article/pii/S2214860425003926)
- [GitHub Repository (BaratiLab)](https://github.com/BaratiLab/LLM-3D-Print-Large-Language-Models-To-Monitor-and-Control-3D-Printing)
- [PrinterChat Project Website (CMU)](https://sites.google.com/andrew.cmu.edu/printerchat)
- [CMU Engineering News: AI Saves 3D Prints](https://engineering.cmu.edu/news-events/news/2026/02/06-ai-saves-3d-prints.html)
- [Tom's Hardware Coverage](https://www.tomshardware.com/3d-printing/researchers-use-agentic-ai-to-monitor-and-correct-3d-prints-system-catches-errors-in-real-time-uses-modular-design-to-work-on-different-makes-and-models)
- [3printr.com Coverage](https://www.3printr.com/3d-printing-monitoring-with-ai-llms-are-designed-to-detect-printing-errors-and-readjust-parameters-1886773/)
- [HuggingFace Paper Page](https://huggingface.co/papers/2408.14307)
- [OpenBambuAPI MQTT Documentation](https://github.com/Doridian/OpenBambuAPI/blob/main/mqtt.md)
- [bambulabs-api Python Library](https://pypi.org/project/bambulabs-api/)
- [OctoEverywhere Bambu Connect](https://octoeverywhere.com/bambu)
- [Obico (The Spaghetti Detective)](https://www.obico.io/)
- [ChatGPT AM Troubleshooting (Brion & Pattinson, 2023)](https://www.sciencedirect.com/science/article/pii/S2542504823000192)
- [GLLM: Self-Corrective G-Code Generation](https://arxiv.org/abs/2501.17584)
- [Bambu Lab Third-Party Integration Wiki](https://wiki.bambulab.com/en/software/third-party-integration)
