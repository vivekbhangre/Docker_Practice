<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <!DOCTYPE html>
    <html lang="en">

    <head>
        <meta charset="UTF-8" />
        <meta name="viewport" content="width=device-width, initial-scale=1.0" />
        <title>DevOps Pipeline | Jenkins + Maven + GitHub + Tomcat</title>
        <link rel="preconnect" href="https://fonts.googleapis.com" />
        <link
            href="https://fonts.googleapis.com/css2?family=Syne:wght@400;700;800&family=JetBrains+Mono:wght@300;400;600&display=swap"
            rel="stylesheet" />
        <style>
            *,
            *::before,
            *::after {
                box-sizing: border-box;
                margin: 0;
                padding: 0;
            }

            :root {
                --bg: #0a0c10;
                --surface: #111318;
                --card: #161a22;
                --border: #1f2533;
                --accent: #00e5a0;
                --accent2: #0080ff;
                --warn: #f97316;
                --text: #e2e8f0;
                --muted: #64748b;
                --mono: 'JetBrains Mono', monospace;
                --display: 'Syne', sans-serif;
            }

            html {
                scroll-behavior: smooth;
            }

            body {
                background: var(--bg);
                color: var(--text);
                font-family: var(--mono);
                font-size: 15px;
                line-height: 1.7;
                overflow-x: hidden;
            }

            /* ─── SCROLLBAR ─── */
            ::-webkit-scrollbar {
                width: 6px;
            }

            ::-webkit-scrollbar-track {
                background: var(--bg);
            }

            ::-webkit-scrollbar-thumb {
                background: var(--border);
                border-radius: 3px;
            }

            /* ─── GRID NOISE OVERLAY ─── */
            body::before {
                content: '';
                position: fixed;
                inset: 0;
                background-image:
                    linear-gradient(var(--border) 1px, transparent 1px),
                    linear-gradient(90deg, var(--border) 1px, transparent 1px);
                background-size: 60px 60px;
                opacity: 0.18;
                pointer-events: none;
                z-index: 0;
            }

            /* ─── NAVBAR ─── */
            nav {
                position: fixed;
                top: 0;
                left: 0;
                right: 0;
                z-index: 100;
                display: flex;
                align-items: center;
                justify-content: space-between;
                padding: 0 5%;
                height: 64px;
                background: rgba(10, 12, 16, 0.85);
                backdrop-filter: blur(14px);
                border-bottom: 1px solid var(--border);
            }

            .logo {
                font-family: var(--display);
                font-weight: 800;
                font-size: 1.15rem;
                letter-spacing: -0.02em;
                color: var(--accent);
            }

            .logo span {
                color: var(--text);
            }

            nav ul {
                display: flex;
                gap: 2rem;
                list-style: none;
            }

            nav ul a {
                text-decoration: none;
                color: var(--muted);
                font-size: 0.78rem;
                letter-spacing: 0.1em;
                text-transform: uppercase;
                transition: color 0.2s;
            }

            nav ul a:hover {
                color: var(--accent);
            }

            .nav-btn {
                background: var(--accent);
                color: var(--bg) !important;
                padding: 6px 18px;
                border-radius: 4px;
                font-weight: 600 !important;
            }

            .nav-btn:hover {
                background: #00c489;
                color: var(--bg) !important;
            }

            /* ─── HERO ─── */
            #hero {
                position: relative;
                min-height: 100vh;
                display: flex;
                flex-direction: column;
                align-items: center;
                justify-content: center;
                text-align: center;
                padding: 100px 5% 60px;
                z-index: 1;
            }

            .hero-tag {
                display: inline-flex;
                align-items: center;
                gap: 8px;
                background: rgba(0, 229, 160, 0.08);
                border: 1px solid rgba(0, 229, 160, 0.3);
                color: var(--accent);
                font-size: 0.72rem;
                letter-spacing: 0.12em;
                text-transform: uppercase;
                padding: 6px 16px;
                border-radius: 2px;
                margin-bottom: 28px;
                animation: fadeUp 0.6s ease both;
            }

            .hero-tag::before {
                content: '';
                width: 7px;
                height: 7px;
                background: var(--accent);
                border-radius: 50%;
                animation: pulse 1.5s infinite;
            }

            @keyframes pulse {

                0%,
                100% {
                    opacity: 1;
                    transform: scale(1);
                }

                50% {
                    opacity: 0.4;
                    transform: scale(0.7);
                }
            }

            h1 {
                font-family: var(--display);
                font-weight: 800;
                font-size: clamp(2.8rem, 7vw, 5.5rem);
                line-height: 1.0;
                letter-spacing: -0.04em;
                margin-bottom: 22px;
                animation: fadeUp 0.7s 0.1s ease both;
            }

            h1 .hl {
                color: var(--accent);
            }

            h1 .hl2 {
                color: var(--accent2);
            }

            .hero-sub {
                max-width: 560px;
                color: var(--muted);
                font-size: 0.92rem;
                line-height: 1.8;
                margin-bottom: 42px;
                animation: fadeUp 0.7s 0.2s ease both;
            }

            .hero-actions {
                display: flex;
                gap: 14px;
                flex-wrap: wrap;
                justify-content: center;
                animation: fadeUp 0.7s 0.3s ease both;
            }

            .btn-primary {
                background: var(--accent);
                color: var(--bg);
                padding: 12px 28px;
                border-radius: 4px;
                text-decoration: none;
                font-weight: 600;
                font-size: 0.85rem;
                letter-spacing: 0.03em;
                transition: background 0.2s, transform 0.15s;
            }

            .btn-primary:hover {
                background: #00c489;
                transform: translateY(-2px);
            }

            .btn-outline {
                border: 1px solid var(--border);
                color: var(--text);
                padding: 12px 28px;
                border-radius: 4px;
                text-decoration: none;
                font-size: 0.85rem;
                transition: border-color 0.2s, color 0.2s, transform 0.15s;
            }

            .btn-outline:hover {
                border-color: var(--accent);
                color: var(--accent);
                transform: translateY(-2px);
            }

            /* ─── TERMINAL BLOCK ─── */
            .terminal {
                margin-top: 64px;
                width: 100%;
                max-width: 680px;
                background: var(--surface);
                border: 1px solid var(--border);
                border-radius: 8px;
                overflow: hidden;
                text-align: left;
                animation: fadeUp 0.7s 0.4s ease both;
            }

            .term-bar {
                display: flex;
                align-items: center;
                gap: 7px;
                padding: 10px 16px;
                background: var(--card);
                border-bottom: 1px solid var(--border);
            }

            .dot {
                width: 11px;
                height: 11px;
                border-radius: 50%;
            }

            .d1 {
                background: #ff5f57;
            }

            .d2 {
                background: #febc2e;
            }

            .d3 {
                background: #28c840;
            }

            .term-title {
                margin-left: auto;
                font-size: 0.72rem;
                color: var(--muted);
            }

            .term-body {
                padding: 20px 22px;
                font-size: 0.82rem;
                line-height: 2;
            }

            .term-body .prompt {
                color: var(--accent);
            }

            .term-body .cmd {
                color: var(--text);
            }

            .term-body .ok {
                color: #28c840;
            }

            .term-body .info {
                color: var(--accent2);
            }

            .term-body .warn {
                color: var(--warn);
            }

            .cursor {
                display: inline-block;
                width: 8px;
                height: 14px;
                background: var(--accent);
                vertical-align: middle;
                animation: blink 1s step-end infinite;
            }

            @keyframes blink {
                50% {
                    opacity: 0;
                }
            }

            /* ─── SECTIONS ─── */
            section {
                position: relative;
                z-index: 1;
                padding: 100px 5%;
            }

            .section-tag {
                display: inline-block;
                font-size: 0.7rem;
                letter-spacing: 0.14em;
                text-transform: uppercase;
                color: var(--accent);
                margin-bottom: 14px;
            }

            h2 {
                font-family: var(--display);
                font-weight: 800;
                font-size: clamp(1.8rem, 4vw, 2.8rem);
                letter-spacing: -0.03em;
                line-height: 1.1;
                margin-bottom: 18px;
            }

            .sub {
                color: var(--muted);
                font-size: 0.88rem;
                max-width: 500px;
                line-height: 1.8;
                margin-bottom: 56px;
            }

            /* ─── PIPELINE SECTION ─── */
            #pipeline {
                background: var(--surface);
                border-top: 1px solid var(--border);
                border-bottom: 1px solid var(--border);
            }

            .pipeline-wrap {
                display: flex;
                gap: 0;
                align-items: stretch;
                overflow-x: auto;
                padding-bottom: 8px;
            }

            .pipe-step {
                flex: 1;
                min-width: 160px;
                background: var(--card);
                border: 1px solid var(--border);
                border-radius: 6px;
                padding: 28px 20px 24px;
                position: relative;
                transition: border-color 0.25s, transform 0.25s;
            }

            .pipe-step:hover {
                border-color: var(--accent);
                transform: translateY(-4px);
            }

            .pipe-step+.pipe-step {
                margin-left: 2px;
            }

            .pipe-step:not(:last-child)::after {
                content: '→';
                position: absolute;
                right: -18px;
                top: 50%;
                transform: translateY(-50%);
                color: var(--muted);
                font-size: 1.1rem;
                z-index: 2;
            }

            .pipe-icon {
                width: 44px;
                height: 44px;
                border-radius: 8px;
                display: flex;
                align-items: center;
                justify-content: center;
                margin-bottom: 16px;
                font-size: 1.4rem;
            }

            .p-green {
                background: rgba(0, 229, 160, 0.12);
            }

            .p-blue {
                background: rgba(0, 128, 255, 0.12);
            }

            .p-orange {
                background: rgba(249, 115, 22, 0.12);
            }

            .p-purple {
                background: rgba(139, 92, 246, 0.12);
            }

            .p-teal {
                background: rgba(20, 184, 166, 0.12);
            }

            .pipe-step h3 {
                font-family: var(--display);
                font-size: 0.95rem;
                font-weight: 700;
                margin-bottom: 6px;
            }

            .pipe-step p {
                font-size: 0.76rem;
                color: var(--muted);
                line-height: 1.6;
            }

            .pipe-num {
                position: absolute;
                top: 12px;
                right: 14px;
                font-size: 0.68rem;
                color: var(--border);
                letter-spacing: 0.1em;
            }

            /* ─── TECH STACK ─── */
            .stack-grid {
                display: grid;
                grid-template-columns: repeat(auto-fit, minmax(240px, 1fr));
                gap: 20px;
            }

            .stack-card {
                background: var(--card);
                border: 1px solid var(--border);
                border-radius: 8px;
                padding: 28px 24px;
                transition: border-color 0.25s, transform 0.25s;
                cursor: default;
            }

            .stack-card:hover {
                border-color: var(--accent2);
                transform: translateY(-4px);
            }

            .stack-logo {
                font-size: 2rem;
                margin-bottom: 16px;
                display: block;
            }

            .stack-card h3 {
                font-family: var(--display);
                font-weight: 700;
                font-size: 1.1rem;
                margin-bottom: 8px;
            }

            .stack-card p {
                font-size: 0.8rem;
                color: var(--muted);
                line-height: 1.7;
            }

            .stack-tag {
                display: inline-block;
                margin-top: 14px;
                font-size: 0.7rem;
                letter-spacing: 0.1em;
                padding: 3px 10px;
                border-radius: 2px;
                text-transform: uppercase;
            }

            .tag-green {
                background: rgba(0, 229, 160, 0.1);
                color: var(--accent);
            }

            .tag-blue {
                background: rgba(0, 128, 255, 0.1);
                color: var(--accent2);
            }

            .tag-orange {
                background: rgba(249, 115, 22, 0.1);
                color: var(--warn);
            }

            .tag-purple {
                background: rgba(139, 92, 246, 0.1);
                color: #a78bfa;
            }

            /* ─── METRICS ─── */
            #metrics {
                background: var(--surface);
                border-top: 1px solid var(--border);
                border-bottom: 1px solid var(--border);
            }

            .metrics-grid {
                display: grid;
                grid-template-columns: repeat(auto-fit, minmax(180px, 1fr));
                gap: 1px;
                background: var(--border);
                border: 1px solid var(--border);
                border-radius: 8px;
                overflow: hidden;
            }

            .metric-cell {
                background: var(--card);
                padding: 36px 28px;
                text-align: center;
            }

            .metric-num {
                font-family: var(--display);
                font-size: 2.8rem;
                font-weight: 800;
                color: var(--accent);
                line-height: 1;
                margin-bottom: 8px;
            }

            .metric-label {
                font-size: 0.75rem;
                color: var(--muted);
                text-transform: uppercase;
                letter-spacing: 0.1em;
            }

            /* ─── FEATURES ─── */
            .features-grid {
                display: grid;
                grid-template-columns: repeat(auto-fit, minmax(280px, 1fr));
                gap: 20px;
            }

            .feat-card {
                background: var(--card);
                border: 1px solid var(--border);
                border-radius: 8px;
                padding: 28px 24px;
                transition: border-color 0.25s;
            }

            .feat-card:hover {
                border-color: var(--accent);
            }

            .feat-icon {
                font-size: 1.6rem;
                margin-bottom: 14px;
            }

            .feat-card h3 {
                font-family: var(--display);
                font-weight: 700;
                font-size: 1rem;
                margin-bottom: 8px;
            }

            .feat-card p {
                font-size: 0.8rem;
                color: var(--muted);
                line-height: 1.7;
            }

            /* ─── CONFIG CODE BLOCK ─── */
            #config {
                background: var(--surface);
                border-top: 1px solid var(--border);
            }

            .code-tabs {
                display: flex;
                gap: 2px;
                margin-bottom: -1px;
            }

            .ctab {
                padding: 8px 18px;
                font-size: 0.75rem;
                letter-spacing: 0.05em;
                cursor: pointer;
                border: 1px solid var(--border);
                border-bottom: none;
                border-radius: 4px 4px 0 0;
                color: var(--muted);
                background: var(--card);
                transition: color 0.2s;
            }

            .ctab.active {
                color: var(--accent);
                background: var(--surface);
                border-color: var(--border);
            }

            .code-block {
                background: var(--card);
                border: 1px solid var(--border);
                border-radius: 0 6px 6px 6px;
                padding: 28px;
                font-size: 0.8rem;
                line-height: 2;
                overflow-x: auto;
                display: none;
            }

            .code-block.active {
                display: block;
            }

            .kw {
                color: #c678dd;
            }

            .str {
                color: #98c379;
            }

            .cmt {
                color: var(--muted);
                font-style: italic;
            }

            .tag {
                color: #e06c75;
            }

            .atr {
                color: #61afef;
            }

            .val {
                color: #98c379;
            }

            .num {
                color: #d19a66;
            }

            /* ─── FOOTER ─── */
            footer {
                position: relative;
                z-index: 1;
                background: var(--surface);
                border-top: 1px solid var(--border);
                padding: 60px 5% 40px;
            }

            .footer-grid {
                display: grid;
                grid-template-columns: 2fr repeat(3, 1fr);
                gap: 40px;
                margin-bottom: 48px;
            }

            .footer-brand .logo {
                font-size: 1.3rem;
                display: block;
                margin-bottom: 12px;
            }

            .footer-brand p {
                font-size: 0.8rem;
                color: var(--muted);
                line-height: 1.8;
                max-width: 260px;
            }

            .footer-col h4 {
                font-size: 0.72rem;
                text-transform: uppercase;
                letter-spacing: 0.12em;
                color: var(--muted);
                margin-bottom: 16px;
            }

            .footer-col ul {
                list-style: none;
            }

            .footer-col li {
                margin-bottom: 9px;
            }

            .footer-col a {
                text-decoration: none;
                font-size: 0.82rem;
                color: var(--text);
                transition: color 0.2s;
            }

            .footer-col a:hover {
                color: var(--accent);
            }

            .footer-bottom {
                border-top: 1px solid var(--border);
                padding-top: 24px;
                display: flex;
                align-items: center;
                justify-content: space-between;
                font-size: 0.75rem;
                color: var(--muted);
            }

            .status-dot {
                display: inline-flex;
                align-items: center;
                gap: 6px;
            }

            .status-dot::before {
                content: '';
                width: 7px;
                height: 7px;
                background: #28c840;
                border-radius: 50%;
                animation: pulse 2s infinite;
            }

            /* ─── DIVIDER ─── */
            .divider {
                border: none;
                border-top: 1px solid var(--border);
                margin: 0;
            }

            /* ─── ANIMATIONS ─── */
            @keyframes fadeUp {
                from {
                    opacity: 0;
                    transform: translateY(22px);
                }

                to {
                    opacity: 1;
                    transform: translateY(0);
                }
            }

            .reveal {
                opacity: 0;
                transform: translateY(24px);
                transition: opacity 0.65s ease, transform 0.65s ease;
            }

            .reveal.visible {
                opacity: 1;
                transform: none;
            }

            /* ─── RESPONSIVE ─── */
            @media (max-width: 768px) {
                nav ul {
                    display: none;
                }

                .footer-grid {
                    grid-template-columns: 1fr 1fr;
                }

                .pipe-step:not(:last-child)::after {
                    display: none;
                }

                .pipeline-wrap {
                    flex-direction: column;
                }

                .pipe-step {
                    min-width: unset;
                }

                h1 {
                    font-size: 2.5rem;
                }
            }
        </style>
    </head>

    <body>

        <!-- ─── NAV ─── -->
        <nav>
            <div class="logo">Dev<span>Ops</span>Pipeline</div>
            <ul>
                <li><a href="#pipeline">Pipeline</a></li>
                <li><a href="#stack">Stack</a></li>
                <li><a href="#features">Features</a></li>
                <li><a href="#config">Config</a></li>
                <li><a href="#pipeline" class="nav-btn">View Build</a></li>
            </ul>
        </nav>

        <!-- ─── HERO ─── -->
        <section id="hero">
            <div class="hero-tag">CI/CD Automation Pipeline — Active</div>
            <h1>Build. Test.<br /><span class="hl">Deploy.</span> <span class="hl2">Repeat.</span></h1>
            <p class="hero-sub">
                An end-to-end DevOps integration using Jenkins, Maven, GitHub, and Apache Tomcat —
                automating every commit from source to production.
            </p>
            <div class="hero-actions">
                <a href="#pipeline" class="btn-primary">Explore Pipeline</a>
                <a href="#stack" class="btn-outline">View Tech Stack</a>
            </div>

            <div class="terminal">
                <div class="term-bar">
                    <span class="dot d1"></span>
                    <span class="dot d2"></span>
                    <span class="dot d3"></span>
                    <span class="term-title">jenkins-agent ~ build #47</span>
                </div>
                <div class="term-body">
                    <div><span class="prompt">$</span> <span class="cmd">git pull origin main</span></div>
                    <div class="ok">✔ Already up to date.</div>
                    <div><span class="prompt">$</span> <span class="cmd">mvn clean package -DskipTests=false</span>
                    </div>
                    <div class="info">[INFO] Scanning for projects...</div>
                    <div class="info">[INFO] Building devops-webapp 1.0-SNAPSHOT</div>
                    <div class="ok">[INFO] BUILD SUCCESS — 12.4s</div>
                    <div><span class="prompt">$</span> <span class="cmd">curl -T target/devops-webapp.war
                            http://tomcat:8080/manager/...</span></div>
                    <div class="ok">✔ Deployment successful → http://tomcat:8080/devops-webapp</div>
                    <div><span class="prompt">$</span> <span class="cursor"></span></div>
                </div>
            </div>
        </section>

        <hr class="divider" />

        <!-- ─── PIPELINE ─── -->
        <section id="pipeline">
            <div class="section-tag">// how it works</div>
            <h2>Automated CI/CD<br />Pipeline Flow</h2>
            <p class="sub">Every push to GitHub triggers a fully automated chain — from code checkout to live deployment
                on Tomcat — orchestrated by Jenkins.</p>
            <div class="pipeline-wrap reveal">
                <div class="pipe-step">
                    <span class="pipe-num">01</span>
                    <div class="pipe-icon p-blue">🐙</div>
                    <h3>Code Push</h3>
                    <p>Developer pushes to GitHub. Webhook fires instantly to Jenkins.</p>
                </div>
                <div class="pipe-step">
                    <span class="pipe-num">02</span>
                    <div class="pipe-icon p-orange">⚙️</div>
                    <h3>SCM Checkout</h3>
                    <p>Jenkins polls/receives webhook and checks out latest source code.</p>
                </div>
                <div class="pipe-step">
                    <span class="pipe-num">03</span>
                    <div class="pipe-icon p-purple">🔨</div>
                    <h3>Maven Build</h3>
                    <p>mvn clean install compiles source, resolves dependencies, packages WAR.</p>
                </div>
                <div class="pipe-step">
                    <span class="pipe-num">04</span>
                    <div class="pipe-icon p-green">🧪</div>
                    <h3>Unit Tests</h3>
                    <p>JUnit tests run automatically. Build fails fast on any regression.</p>
                </div>
                <div class="pipe-step">
                    <span class="pipe-num">05</span>
                    <div class="pipe-icon p-teal">🚀</div>
                    <h3>Deploy</h3>
                    <p>WAR artifact deployed to Apache Tomcat via Deploy Plugin or SCP.</p>
                </div>
            </div>
        </section>

        <!-- ─── METRICS ─── -->
        <section id="metrics">
            <div class="metrics-grid reveal">
                <div class="metric-cell">
                    <div class="metric-num">~40s</div>
                    <div class="metric-label">Avg. Build Time</div>
                </div>
                <div class="metric-cell">
                    <div class="metric-num">100%</div>
                    <div class="metric-label">Automated Deploys</div>
                </div>
                <div class="metric-cell">
                    <div class="metric-num">4</div>
                    <div class="metric-label">Integrated Tools</div>
                </div>
                <div class="metric-cell">
                    <div class="metric-num">0</div>
                    <div class="metric-label">Manual Steps</div>
                </div>
            </div>
        </section>

        <!-- ─── TECH STACK ─── -->
        <section id="stack">
            <div class="section-tag">// technologies</div>
            <h2>The Stack Behind<br />Every Build</h2>
            <p class="sub">Four battle-tested tools working in concert to automate your entire software delivery
                lifecycle.</p>
            <div class="stack-grid reveal">
                <div class="stack-card">
                    <span class="stack-logo">🏗️</span>
                    <h3>Jenkins</h3>
                    <p>Open-source automation server. Orchestrates the entire CI/CD pipeline via Jenkinsfile declarative
                        syntax, with hundreds of plugins.</p>
                    <span class="stack-tag tag-orange">Automation Server</span>
                </div>
                <div class="stack-card">
                    <span class="stack-logo">📦</span>
                    <h3>Apache Maven</h3>
                    <p>Project lifecycle management and build automation. Handles dependency resolution, compilation,
                        testing, and WAR packaging.</p>
                    <span class="stack-tag tag-blue">Build Tool</span>
                </div>
                <div class="stack-card">
                    <span class="stack-logo">🐙</span>
                    <h3>GitHub</h3>
                    <p>Source code repository with webhook integration. Every git push to main triggers the Jenkins
                        pipeline automatically in seconds.</p>
                    <span class="stack-tag tag-purple">Source Control</span>
                </div>
                <div class="stack-card">
                    <span class="stack-logo">🐱</span>
                    <h3>Apache Tomcat</h3>
                    <p>Java Servlet container that hosts the deployed WAR artifact. Receives deployments via Jenkins
                        Deploy Plugin or cURL upload.</p>
                    <span class="stack-tag tag-green">App Server</span>
                </div>
            </div>
        </section>

        <!-- ─── FEATURES ─── -->
        <section id="features" style="border-top: 1px solid var(--border);">
            <div class="section-tag">// capabilities</div>
            <h2>What This Pipeline<br />Gives You</h2>
            <p class="sub">Production-grade automation patterns built into every stage of the delivery process.</p>
            <div class="features-grid reveal">
                <div class="feat-card">
                    <div class="feat-icon">⚡</div>
                    <h3>Instant Feedback</h3>
                    <p>Developers get build results within seconds of pushing code via Jenkins build notifications and
                        console output.</p>
                </div>
                <div class="feat-card">
                    <div class="feat-icon">🔁</div>
                    <h3>Repeatable Builds</h3>
                    <p>Maven ensures every build is deterministic and reproducible with pinned dependency versions in
                        pom.xml.</p>
                </div>
                <div class="feat-card">
                    <div class="feat-icon">🔐</div>
                    <h3>Credential Management</h3>
                    <p>Jenkins Credentials Store securely manages GitHub tokens, Tomcat manager passwords, and SSH keys.
                    </p>
                </div>
                <div class="feat-card">
                    <div class="feat-icon">📊</div>
                    <h3>Build History</h3>
                    <p>Full audit trail of every build — logs, test reports, artifacts, and duration metrics stored by
                        Jenkins.</p>
                </div>
                <div class="feat-card">
                    <div class="feat-icon">🛡️</div>
                    <h3>Fail-Fast Testing</h3>
                    <p>JUnit tests run at the package phase. A failing test aborts the pipeline before any deployment
                        occurs.</p>
                </div>
                <div class="feat-card">
                    <div class="feat-icon">🌿</div>
                    <h3>Branch Strategies</h3>
                    <p>Multi-branch pipelines allow separate CI/CD flows per git branch — dev, staging, and production
                        environments.</p>
                </div>
            </div>
        </section>

        <!-- ─── CONFIG ─── -->
        <section id="config">
            <div class="section-tag">// configuration</div>
            <h2>Sample Configuration<br />Files</h2>
            <p class="sub">Real-world snippets from this project's core configuration files.</p>
            <div class="code-tabs">
                <button class="ctab active" onclick="showTab('jenkinsfile', this)">Jenkinsfile</button>
                <button class="ctab" onclick="showTab('pomxml', this)">pom.xml</button>
                <button class="ctab" onclick="showTab('webxml', this)">web.xml</button>
            </div>

            <div id="jenkinsfile" class="code-block active reveal">
                <span class="kw">pipeline</span> {<br />
                &nbsp;&nbsp;<span class="kw">agent</span> any<br />
                &nbsp;&nbsp;<span class="kw">tools</span> { maven <span class="str">'Maven3'</span>; jdk <span
                    class="str">'JDK17'</span> }<br />
                &nbsp;&nbsp;<span class="kw">stages</span> {<br />
                &nbsp;&nbsp;&nbsp;&nbsp;<span class="kw">stage</span>(<span class="str">'Checkout'</span>) {<br />
                &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;steps { git branch: <span class="str">'main'</span>, url: <span
                    class="str">'https://github.com/user/devops-webapp.git'</span> }<br />
                &nbsp;&nbsp;&nbsp;&nbsp;}<br />
                &nbsp;&nbsp;&nbsp;&nbsp;<span class="kw">stage</span>(<span class="str">'Build'</span>) {<br />
                &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;steps { sh <span class="str">'mvn clean package'</span> }<br />
                &nbsp;&nbsp;&nbsp;&nbsp;}<br />
                &nbsp;&nbsp;&nbsp;&nbsp;<span class="kw">stage</span>(<span class="str">'Test'</span>) {<br />
                &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;steps { sh <span class="str">'mvn test'</span> }<br />
                &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;post { always { junit <span
                    class="str">'**/target/surefire-reports/*.xml'</span> } }<br />
                &nbsp;&nbsp;&nbsp;&nbsp;}<br />
                &nbsp;&nbsp;&nbsp;&nbsp;<span class="kw">stage</span>(<span class="str">'Deploy'</span>) {<br />
                &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;steps {<br />
                &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;deploy adapters: [tomcat9(path: <span
                    class="str">'/devops-webapp'</span>,<br />
                &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;url:
                <span class="str">'http://localhost:8080'</span>,<br />
                &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;credentialsId:
                <span class="str">'tomcat-creds'</span>)],<br />
                &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;contextPath: <span
                    class="str">'/devops-webapp'</span>,<br />
                &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;war: <span
                    class="str">'**/*.war'</span><br />
                &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;}<br />
                &nbsp;&nbsp;&nbsp;&nbsp;}<br />
                &nbsp;&nbsp;}<br />
                }
            </div>

            <div id="pomxml" class="code-block">
                <span class="tag">&lt;project</span> <span class="atr">xmlns</span>=<span
                    class="val">"http://maven.apache.org/POM/4.0.0"</span><span class="tag">&gt;</span><br />
                &nbsp;&nbsp;<span class="tag">&lt;modelVersion&gt;</span><span class="num">4.0.0</span><span
                    class="tag">&lt;/modelVersion&gt;</span><br />
                &nbsp;&nbsp;<span class="tag">&lt;groupId&gt;</span>com.devops<span
                    class="tag">&lt;/groupId&gt;</span><br />
                &nbsp;&nbsp;<span class="tag">&lt;artifactId&gt;</span>devops-webapp<span
                    class="tag">&lt;/artifactId&gt;</span><br />
                &nbsp;&nbsp;<span class="tag">&lt;version&gt;</span>1.0-SNAPSHOT<span
                    class="tag">&lt;/version&gt;</span><br />
                &nbsp;&nbsp;<span class="tag">&lt;packaging&gt;</span>war<span
                    class="tag">&lt;/packaging&gt;</span><br /><br />
                &nbsp;&nbsp;<span class="tag">&lt;dependencies&gt;</span><br />
                &nbsp;&nbsp;&nbsp;&nbsp;<span class="tag">&lt;dependency&gt;</span><br />
                &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<span class="tag">&lt;groupId&gt;</span>javax.servlet<span
                    class="tag">&lt;/groupId&gt;</span><br />
                &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<span class="tag">&lt;artifactId&gt;</span>javax.servlet-api<span
                    class="tag">&lt;/artifactId&gt;</span><br />
                &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<span class="tag">&lt;version&gt;</span>4.0.1<span
                    class="tag">&lt;/version&gt;</span><br />
                &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<span class="tag">&lt;scope&gt;</span>provided<span
                    class="tag">&lt;/scope&gt;</span><br />
                &nbsp;&nbsp;&nbsp;&nbsp;<span class="tag">&lt;/dependency&gt;</span><br />
                &nbsp;&nbsp;<span class="tag">&lt;/dependencies&gt;</span><br />
                <span class="tag">&lt;/project&gt;</span>
            </div>

            <div id="webxml" class="code-block">
                <span class="tag">&lt;web-app</span> <span class="atr">xmlns</span>=<span
                    class="val">"http://xmlns.jcp.org/xml/ns/javaee"</span><br />
                &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<span class="atr">version</span>=<span
                    class="val">"4.0"</span><span class="tag">&gt;</span><br /><br />
                &nbsp;&nbsp;<span class="tag">&lt;display-name&gt;</span>DevOps Pipeline App<span
                    class="tag">&lt;/display-name&gt;</span><br /><br />
                &nbsp;&nbsp;<span class="tag">&lt;welcome-file-list&gt;</span><br />
                &nbsp;&nbsp;&nbsp;&nbsp;<span class="tag">&lt;welcome-file&gt;</span>index.jsp<span
                    class="tag">&lt;/welcome-file&gt;</span><br />
                &nbsp;&nbsp;<span class="tag">&lt;/welcome-file-list&gt;</span><br /><br />
                &nbsp;&nbsp;<span class="cmt">&lt;!-- Add servlets, filters, and listeners here
                    --&gt;</span><br /><br />
                <span class="tag">&lt;/web-app&gt;</span>
            </div>
        </section>

        <!-- ─── FOOTER ─── -->
        <footer>
            <div class="footer-grid">
                <div class="footer-brand">
                    <span class="logo">Dev<span>Ops</span>Pipeline</span>
                    <p>A fully automated CI/CD integration project built with Jenkins, Maven, GitHub, and Apache Tomcat.
                    </p>
                </div>
                <div class="footer-col">
                    <h4>Pipeline</h4>
                    <ul>
                        <li><a href="#pipeline">Overview</a></li>
                        <li><a href="#pipeline">Stages</a></li>
                        <li><a href="#config">Jenkinsfile</a></li>
                        <li><a href="#config">Configuration</a></li>
                    </ul>
                </div>
                <div class="footer-col">
                    <h4>Stack</h4>
                    <ul>
                        <li><a href="#stack">Jenkins</a></li>
                        <li><a href="#stack">Maven</a></li>
                        <li><a href="#stack">GitHub</a></li>
                        <li><a href="#stack">Tomcat</a></li>
                    </ul>
                </div>
                <div class="footer-col">
                    <h4>Resources</h4>
                    <ul>
                        <li><a href="https://www.jenkins.io/doc/" target="_blank">Jenkins Docs</a></li>
                        <li><a href="https://maven.apache.org/guides/" target="_blank">Maven Guide</a></li>
                        <li><a href="https://tomcat.apache.org/tomcat-10.0-doc/" target="_blank">Tomcat Docs</a></li>
                        <li><a href="https://docs.github.com/en/webhooks" target="_blank">GitHub Webhooks</a></li>
                    </ul>
                </div>
            </div>
            <div class="footer-bottom">
                <span>© 2025 DevOpsPipeline. Built for learning and integration practice.</span>
                <span class="status-dot">All systems operational</span>
            </div>
        </footer>

        <script>
            function showTab(id, btn) {
                document.querySelectorAll('.code-block').forEach(b => b.classList.remove('active'));
                document.querySelectorAll('.ctab').forEach(b => b.classList.remove('active'));
                document.getElementById(id).classList.add('active');
                btn.classList.add('active');
            }

            const observer = new IntersectionObserver((entries) => {
                entries.forEach(e => { if (e.isIntersecting) e.target.classList.add('visible'); });
            }, { threshold: 0.12 });
            document.querySelectorAll('.reveal').forEach(el => observer.observe(el));
        </script>
    </body>

    </html>