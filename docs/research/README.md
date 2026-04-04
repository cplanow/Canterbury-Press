# AI-Assisted 3D Printing Research

Research conducted March–April 2026 evaluating AI tools and frameworks for integration with the Canterbury Press 3D printing workflow (Bambu Lab P1S + OpenSCAD + FreeCAD).

## Research Documents

| Document | Summary |
|----------|---------|
| [AI 3D Printing Design Guide](ai-3d-printing-design-guide.md) | Comprehensive workflow guide covering code-generation pipelines, text-to-CAD platforms, and agentic workflows with practical prompt engineering and P1S constraints. |
| [DesignBench.ai](designbench-ai.md) | LLM-powered text-to-OpenSCAD-to-STL generator. Pre-alpha/dormant, but the technique it proved is now widely adopted. |
| [Hitem3D](hitem3d.md) | AI image/text-to-3D mesh generator. High-fidelity organic models, not suited for dimensionally precise functional parts. |
| [LLM-3D Print (CMU)](llm-3d-print.md) | Multi-agent LLM framework for autonomous real-time 3D print error detection and correction. Open source, adaptable to P1S via MQTT. |
| [AI 3D Printing Landscape](ai-3d-printing-landscape.md) | Survey of AI tools across text-to-3D, text-to-CAD, print monitoring, and slicer optimization. |
| [Recommended Tool Stack](recommended-tools.md) | Prioritized recommendations for Canterbury Press, organized by implementation tier. |

## Key Findings

1. **LLM + OpenSCAD is the highest-leverage integration** for functional part design. Multiple open-source MCP servers and agents exist for iterative parametric design.

2. **The openscad-agent project** provides Claude Code skills (`/openscad`, `/preview-scad`, `/export-stl`) for versioned, iterative 3D modeling with visual feedback.

3. **The Bambu MCP server** (`bambu-mcp`) provides 25 tools for direct P1S control via local MQTT — print control, camera, AMS, temperature, file upload — with built-in safety guardrails.

4. **CadQuery** (Python + Open CASCADE kernel) is a more powerful alternative to OpenSCAD when fillets, chamfers, STEP export, or complex geometry are needed. Fine-tuned LLMs achieve 69.3% accuracy on CadQuery generation tasks.

5. **Text-to-3D mesh generators** (Hitem3D, Meshy, Tripo) produce organic/artistic models only — not dimensionally accurate engineering parts.

6. **Obico** (self-hosted, free) is the production standard for AI print failure detection on the P1S.

7. **LLM-3D Print** (CMU) is the most advanced framework for autonomous print correction, with a feasible path to P1S adaptation.

8. **FDM design rules** (overhangs, bridges, snap-fits, hole design, elephant foot) should be embedded in LLM system context for reliable print-ready output. See [docs/fdm-design-rules.md](../fdm-design-rules.md).

9. **Slicer Copilot** uses LLMs to optimize Bambu Studio print settings from `.3mf` files.

10. **The slicing step remains the automation gap** — no MCP server exists for OrcaSlicer/Bambu Studio, though OrcaSlicer CLI mode is a potential path.
