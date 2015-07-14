require "java"
require "netty-3.6.2.Final.jar"

# HELLO JAVA. I MISSED U.
java_import java.net.InetSocketAddress
java_import java.util.concurrent.Executors
java_import org.jboss.netty.channel.socket.nio.NioClientSocketChannelFactory
java_import org.jboss.netty.channel.socket.nio.NioServerSocketChannelFactory
java_import org.jboss.netty.channel.ChannelFactory
java_import org.jboss.netty.channel.ChannelPipelineFactory
java_import org.jboss.netty.channel.Channels
java_import org.jboss.netty.channel.SimpleChannelUpstreamHandler

class MyPipeline #< ChannelPipelineFactory
  include ChannelPipelineFactory

  def getPipeline
    return Channels.pipeline(Handler.new)
  end
end

class Handler < SimpleChannelUpstreamHandler
  public
  def messageReceived(context, event)
    puts "Got message"
    p context
    p event
  end
end # class handler

factory = NioServerSocketChannelFactory.new(Executors.newCachedThreadPool,
                                            Executors.newCachedThreadPool)

org.jboss.netty.bootstrap.ServerBootstrap.new(factory).tap do |bootstrap|
  bootstrap.setPipelineFactory(MyPipeline.new)
  bootstrap.setOption("child.tcpNoDelay", true)
  bootstrap.setOption("child.keepAlive", true)
  bootstrap.bind(InetSocketAddress.new(2444))
end
