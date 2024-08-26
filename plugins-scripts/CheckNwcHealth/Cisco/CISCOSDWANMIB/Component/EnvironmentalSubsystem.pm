package CheckNwcHealth::Cisco::CISCOSDWANMIB::Component::EnvironmentalSubsystem;
our @ISA = qw(Monitoring::GLPlugin::SNMP::Item);
use strict;

sub init {
  my ($self) = @_;
  $self->{disk_subsystem} =
      CheckNwcHealth::Cisco::CISCOSDWANMIB::Component::DiskSubsystem->new();
  $self->get_snmp_table_objects('CISCO-SDWAN-OPER-SYSTEM-MIB', [
      ['hwenvs', 'CheckNwcHealth::Cisco::CISCOSDWANMIB::Component::EnvironmentalSubsystem::HWEnv'],
  ]);
  $self->get_snmp_objects('CISCO-SDWAN-OPER-SYSTEM-MIB', (qw(
      systemStatusState systemStatusSystemStateDescription
  )));
}

sub check {
  my ($self) = @_;
  $self->{disk_subsystem}->check();
  # lkng-green(0),green(1),yellow(2),red(3)
  $self->add_info(sprintf "system state: %s",
      $self->{systemStatusSystemStateDescription});
  if ($self->{systemStatusState} =~ /green/) {
    $self->add_ok();
  } elsif ($self->{systemStatusState} eq "yellow") {
    $self->add_warning();
  } elsif ($self->{systemStatusState} eq "red") {
    $self->add_critical();
  } else {
    $self->add_unknown();
  }
}

sub dump {
  my ($self) = @_;
  $self->{disk_subsystem}->dump();
  $self->SUPER::dump();
}


package CheckNwcHealth::Cisco::CISCOSDWANMIB::Component::EnvironmentalSubsystem::HWEnv;
our @ISA = qw(Monitoring::GLPlugin::SNMP::TableItem);
use strict;


