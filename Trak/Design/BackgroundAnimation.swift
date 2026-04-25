import SwiftUI


struct Particle {
    var id = UUID()
    var position: CGPoint
    var velocity: CGVector
    var life: Double
    var size: CGFloat
}

final class ParticleSystem: ObservableObject {
    @Published var particles: [Particle] = []

    var bounds: CGRect = .zero
    var spawnRate: Double = 80 // particles per second
    var maxParticles = 120
    var lastSpawnRemainder: Double = 0

    // tuning
    var maxSpeed: CGFloat = 40
    var minSize: CGFloat = 1.0
    var maxSize: CGFloat = 3.5
    var maxLife: Double = 8.0

    func configure(bounds: CGRect) {
        self.bounds = bounds
        if particles.isEmpty {
            for _ in 0..<30 { spawnParticle() }
        }
    }

    func update(delta: Double) {
        guard bounds.width > 0 else { return }

        let toSpawnExact = spawnRate * delta + lastSpawnRemainder
        let toSpawn = Int(toSpawnExact)
        lastSpawnRemainder = toSpawnExact - Double(toSpawn)

        for _ in 0..<toSpawn {
            if particles.count < maxParticles { spawnParticle() }
        }

        var newParticles: [Particle] = []
        for var p in particles {
            p.life -= delta
            if p.life <= 0 { continue }

            p.position.x += p.velocity.dx * CGFloat(delta)
            p.position.y += p.velocity.dy * CGFloat(delta)

            if p.position.x < 0 {
                p.position.x = 0
                p.velocity.dx *= -1
            } else if p.position.x > bounds.width {
                p.position.x = bounds.width
                p.velocity.dx *= -1
            }
            if p.position.y < 0 {
                p.position.y = 0
                p.velocity.dy *= -1
            } else if p.position.y > bounds.height {
                p.position.y = bounds.height
                p.velocity.dy *= -1
            }

            newParticles.append(p)
        }

        if newParticles.count > maxParticles {
            newParticles = Array(newParticles.prefix(maxParticles))
        }

        DispatchQueue.main.async {
            self.particles = newParticles
        }
    }

    private func spawnParticle() {
        guard bounds.width > 0 else { return }
        let x = CGFloat.random(in: 0...bounds.width)
        let y = CGFloat.random(in: 0...bounds.height)
        let angle = Double.random(in: 0..<(2 * .pi))
        let speed = Double.random(in: 6...Double(maxSpeed))
        let vx = CGFloat(cos(angle) * speed)
        let vy = CGFloat(sin(angle) * speed)
        let size = CGFloat.random(in: minSize...maxSize)
        let life = Double.random(in: maxLife * 0.6...maxLife)

        let p = Particle(position: CGPoint(x: x, y: y), velocity: CGVector(dx: vx, dy: vy), life: life, size: size)
        particles.append(p)
    }
}

struct DynamicLineParticleView: View {
    @StateObject private var system = ParticleSystem()
    @State private var lastDate = Date()

    var connectionDistance: CGFloat = 90
    var lineWidth: CGFloat = 0.6

    var body: some View {
        GeometryReader { geo in
            TimelineView(.animation) { (timeline: TimelineViewDefaultContext) in
                let now = timeline.date
                let dt = now.timeIntervalSince(lastDate)
                let delta = min(max(dt, 0.001), 0.05)
                

                Canvas { context, size in
                    if system.bounds.size != CGSize(width: size.width, height: size.height) {
                        system.configure(bounds: CGRect(origin: .zero, size: size))
                    }

                    system.update(delta: delta)

                    var particlePositions: [CGPoint] = []
                    for p in system.particles {
                        particlePositions.append(p.position)

                        let lifeRatio = max(0, min(1, p.life / system.maxLife))
                        let alpha = lifeRatio * 0.95

                        let rect = CGRect(x: p.position.x - p.size/2, y: p.position.y - p.size/2, width: p.size, height: p.size)
                        context.fill(Path(ellipseIn: rect), with: .color(Color.white.opacity(alpha)))
                    }

                    let count = particlePositions.count
                    if count > 1 {
                        for i in 0..<count {
                            let a = particlePositions[i]
                            var j = i + 1
                            while j < count {
                                let b = particlePositions[j]
                                let dx = a.x - b.x
                                let dy = a.y - b.y
                                let dist = sqrt(dx*dx + dy*dy)
                                if dist < connectionDistance {
                                    let strength = 1.0 - (dist / connectionDistance)
                                    let lineAlpha = Double(strength) * 0.7
                                    var path = Path()
                                    path.move(to: a)
                                    path.addLine(to: b)
                                    context.stroke(path, with: .color(Color.white.opacity(lineAlpha)), lineWidth: lineWidth)
                                }
                                j += 1
                            }
                        }
                    }
                }
                .drawingGroup()
                .background(Color.black)
                .ignoresSafeArea()
                .onAppear {
                    self.lastDate = Date()
                }
            }
            .opacity(0.2)
        }
    }
        
}

struct DynamicLineParticleView_Previews: PreviewProvider {
    static var previews: some View {
        DynamicLineParticleView()
            .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}
