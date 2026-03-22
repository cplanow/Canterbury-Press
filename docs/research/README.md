# AI-Assisted 3D Printing Research

Research conducted March 2026 evaluating AI tools and frameworks for integration with the Canterbury Press 3D printing workflow (Bambu Lab P1S + OpenSCAD + FreeCAD).

## Research Documents

| Document | Summary |
|----------|---------|
| [DesignBench.ai](designbench-ai.md) | LLM-powered text-to-OpenSCAD-to-STL generator. Pre-alpha/dormant, but the technique it proved is now widely adopted. |
| [Hitem3D](hitem3d.md) | AI image/text-to-3D mesh generator. High-fidelity organic models, not suited for dimensionally precise functional parts. |
| [LLM-3D Print (CMU)](llm-3d-print.md) | Multi-agent LLM framework for autonomous real-time 3D print error detection and correction. Open source, adaptable to P1S via MQTT. |
| [AI 3D Printing Landscape](ai-3d-printing-landscape.md) | Comprehensive survey of AI tools across text-to-3D, text-to-CAD, print monitoring, and slicer optimization. |
| [Recommended Tool Stack](recommended-tools.md) | Prioritized recommendations for Canterbury Press integration, organized by implementation tier. |

## Key Findings

1. **LLM + OpenSCAD is the highest-leverage integration** for functional part design. Multiple open-source MCP servers exist to connect Claude/ChatGPT directly to OpenSCAD for iterative parametric design.

2. **Text-to-3D mesh generators** (Hitem3D, Meshy, Tripo) produce organic/artistic models, not dimensionally accurate engineering parts. Useful for decorative elements only.

3. **Obico** (self-hosted, free) is the production-ready standard for AI print failure detection on the P1S.

4. **LLM-3D Print** is the most advanced research framework for autonomous print correction, with a feasible but non-trivial path to P1S adaptation via MQTT.

5. **Slicer Copilot** is an open-source tool that uses LLMs to optimize Bambu Studio print settings.
