import React, { useState, useEffect } from 'react';

function App() {
  // State 1: Active Cluster Pods list
  const [pods, setPods] = useState([
    { id: "POD-01", name: "auth-service-pod", status: "RUNNING", cpu: "12%", memory: "142MB", color: "#10b981" },
    { id: "POD-02", name: "payment-gateway-pod", status: "RUNNING", cpu: "24%", memory: "210MB", color: "#10b981" },
    { id: "POD-03", name: "analytics-worker-pod", status: "STABLE", cpu: "08%", memory: "95MB", color: "#10b981" },
  ]);

  // State 2: Selected active filter namespace
  const [namespace, setNamespace] = useState("all-namespaces");

  // State 3: Live terminal telemetry log collection stream
  const [logs, setLogs] = useState([
    { time: "15:42:01", msg: "Initializing handshake sequence with EC2 Host Controller..." },
    { time: "15:42:03", msg: "Cluster API Bridge confirmed open on Standard Port 80." }
  ]);

  // Interactive Action: Simulates scaling up a new microservices pod inside React state
  const scaleReplica = () => {
    const podNum = pods.length + 1;
    const newPod = {
      id: `POD-0${podNum}`,
      name: `async-worker-0${podNum}-pod`,
      status: "INITIALIZING",
      cpu: "00%",
      memory: "16MB",
      color: "#f59e0b" // Amber color during initialization
    };

    setPods([...pods, newPod]);
    
    // Append tracking message onto live terminal simulation state
    setLogs(prev => [
      ...prev, 
      { time: new Date().toLocaleTimeString(), msg: `kubectl scale deployment/async-worker --replicas=${podNum} successful.` }
    ]);
  };

  // Lifecycle Effect: Simulates live pod telemetry metrics updates every few seconds
  useEffect(() => {
    const interval = setInterval(() => {
      setPods(prevPods => 
        prevPods.map(pod => {
          if (pod.status === "INITIALIZING") {
            return { ...pod, status: "RUNNING", cpu: "14%", memory: "88MB", color: "#10b981" };
          }
          // Shift active specs slightly to mimic an actual server monitoring window
          const randomCpu = Math.floor(Math.random() * 30) + 5;
          return { ...pod, cpu: `${randomCpu}%` };
        })
      );
    }, 4000);

    return () => clearInterval(interval);
  }, [pods]);

  // Premium Custom Theme Styling Matrices
  const styles = {
    body: { backgroundColor: '#090514', color: '#e0d7f5', fontFamily: 'monospace', minHeight: '100vh', padding: '2rem' },
    header: { maxWidth: '1200px', margin: '0 auto 2rem auto', borderBottom: '1px solid rgba(168, 85, 247, 0.3)', paddingBottom: '1rem', display: 'flex', justifyContent: 'space-between', alignItems: 'center' },
    title: { fontSize: '1.75rem', fontWeight: '900', letterSpacing: '0.15em', background: 'linear-gradient(to right, #c084fc, #6366f1)', WebkitBackgroundClip: 'text', WebkitTextFillColor: 'transparent' },
    pulsePoint: { width: '12px', height: '12px', backgroundColor: '#a855f7', borderRadius: '50%', boxShadow: '0 0 12px #a855f7' },
    grid: { maxWidth: '1200px', margin: '0 auto', display: 'grid', gridTemplateColumns: 'repeat(auto-fit, minmax(300px, 1fr))', gap: '1.5rem' },
    card: { backgroundColor: '#120d24', border: '1px solid #2e165b', borderRadius: '8px', padding: '1.5rem', boxShadow: '0 10px 25px -5px rgba(0,0,0,0.5)' },
    cardTitle: { fontSize: '0.8rem', fontWeight: 'bold', textTransform: 'uppercase', tracking: '0.1em', color: '#c084fc', marginBottom: '1rem' },
    metricRow: { display: 'flex', justifyContent: 'space-between', borderBottom: '1px solid rgba(46, 22, 91, 0.5)', paddingBottom: '0.5rem', marginBottom: '0.5rem', fontSize: '0.9rem' },
    btn: { backgroundColor: '#7c3aed', color: '#ffffff', fontWeight: 'bold', fontSize: '0.75rem', letterSpacing: '0.1em', padding: '0.75rem 1.25rem', border: 'none', borderRadius: '4px', cursor: 'pointer', textTransform: 'uppercase', transition: 'background 0.2s' },
    terminal: { backgroundColor: '#000000', border: '1px solid #2e165b', borderRadius: '4px', padding: '1rem', height: '180px', overflowY: 'auto', fontSize: '0.75rem', color: '#a78bfa' }
  };

  return (
    <div style={styles.body}>
      
      {/* Top Banner Navigation */}
      <header style={styles.header}>
        <div>
          <h1 style={styles.title}>KUBE_CORE // CONTAINER_ORCHESTRATOR</h1>
          <p style={{ fontSize: '0.7rem', color: '#94a3b8', marginTop: '0.25rem' }}>Engine: React.js UI Platform Core Layer</p>
        </div>
        <div style={{ display: 'flex', alignItems: 'center', gap: '0.5rem' }}>
          <div style={styles.pulsePoint}></div>
          <span style={{ fontSize: '0.7rem', fontWeight: 'bold', color: '#a855f7', letterSpacing: '0.1em' }}>CLUSTER LINKED</span>
        </div>
      </header>

      {/* Analytics Layout Grid */}
      <main style={styles.grid}>
        
        {/* Box 1: UI Engine Profile */}
        <div style={styles.card}>
          <h3 style={styles.cardTitle}>// Runtime Node Environment</h3>
          <div style={styles.metricRow}><span>Framework Profile:</span><span style={{ color: '#cbd5e1' }}>React 18 Architecture</span></div>
          <div style={styles.metricRow}><span>Production Server:</span><span style={{ color: '#cbd5e1' }}>Nginx Reverse-Proxy Container</span></div>
          <div style={{ ...styles.metricRow, border: 'none', padding: '0', margin: '0' }}><span>Compilation Path:</span><span style={{ color: '#f43f5e', fontWeight: 'bold' }}>Multi-Stage Production Build</span></div>
        </div>

        {/* Box 2: Configuration Context */}
        <div style={styles.card}>
          <h3 style={styles.cardTitle}>// Container Networking Vectors</h3>
          <div style={styles.metricRow}><span>Ingress Port:</span><span style={{ color: '#cbd5e1' }}>Host Port 80 ➔ Container Port 80</span></div>
          <div style={styles.metricRow}><span>Target Deployment:</span><span style={{ color: '#cbd5e1' }}>AWS Cloud (Amazon Linux)</span></div>
          <div style={{ ...styles.metricRow, border: 'none', padding: '0', margin: '0' }}><span>System Isolation:</span><span style={{ color: '#a855f7', fontWeight: 'bold' }}>Active Docker Matrix</span></div>
        </div>

        {/* Box 3: Runtime Operations Control */}
        <div style={styles.card}>
          <h3 style={styles.cardTitle}>// Node Orchestration Control</h3>
          <p style={{ fontSize: '0.8rem', color: '#94a3b8', marginBottom: '1rem' }}>Dynamically request immediate container allocation adjustments on the EC2 host environment:</p>
          <button 
            style={styles.btn} 
            onClick={scaleReplica}
            onMouseOver={(e) => e.target.style.backgroundColor = '#6d28d9'}
            onMouseOut={(e) => e.target.style.backgroundColor = '#7c3aed'}
          >
            Scale Deployment Pods (+)
          </button>
        </div>

        {/* Interactive Cluster Pod Status Dashboard */}
        <div style={{ ...styles.card, gridColumn: '1 / -1' }}>
          <h3 style={styles.cardTitle}>// Active Cluster Pods Status (Live Telemetry Updates)</h3>
          
          <div style={{ display: 'grid', gridTemplateColumns: 'repeat(auto-fit, minmax(240px, 1fr))', gap: '1rem', marginBottom: '1.5rem' }}>
            {pods.map(pod => (
              <div key={pod.id} style={{ backgroundColor: '#1a1336', border: `1px solid ${pod.color}50`, padding: '1rem', borderRadius: '4px' }}>
                <div style={{ display: 'flex', justifyContent: 'space-between', alignItems: 'center', marginBottom: '0.5rem' }}>
                  <span style={{ fontSize: '0.75rem', fontWeight: 'bold', color: '#94a3b8' }}>{pod.id}</span>
                  <span style={{ fontSize: '0.65rem', fontWeight: 'bold', backgroundColor: `${pod.color}20`, color: pod.color, padding: '2px 6px', borderRadius: '3px' }}>
                    {pod.status}
                  </span>
                </div>
                <h4 style={{ fontSize: '0.9rem', fontWeight: 'bold', color: '#ffffff', marginBottom: '0.75rem' }}>{pod.name}</h4>
                <div style={{ display: 'flex', justifyContent: 'space-between', fontSize: '0.7rem', color: '#a78bfa' }}>
                  <span>CPU limit: {pod.cpu}</span>
                  <span>RAM size: {pod.memory}</span>
                </div>
              </div>
            ))}
          </div>

          {/* Interactive Shell Monitor Logs Panel */}
          <h3 style={{ ...styles.cardTitle, color: '#94a3b8', fontSize: '0.75rem' }}>// stdout_cluster_telemetry.log</h3>
          <div style={styles.terminal}>
            {logs.map((log, index) => (
              <p key={index} style={{ marginBottom: '0.25rem' }}>
                <span style={{ color: '#5b21b6', marginRight: '0.5rem' }}>[{log.time}]</span> 
                <span style={{ color: '#c084fc' }}>⚡ k8s_matrix_node:</span> {log.msg}
              </p>
            ))}
          </div>
        </div>

      </main>
    </div>
  );
}

export default App;
