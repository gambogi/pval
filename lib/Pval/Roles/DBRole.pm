package Pval::Roles::DBRole;

use strict;
use warnings;
use v5.10;

use Dancer ':moose';
use Moose::Role;

requires 'BUILD';
requires 'commit';

# Hah. Suck on that.
no if $] >= 5.017011, warnings => 'experimental::smartmatch';

has dbic_object => (
    is => 'rw',
    isa => 'DBIx::Class::Core',
);

has 'insert_needed' => (
    is => 'rw',
    isa => 'Bool',
    default => 0,
);

has db_methods => (
    is => 'rw',
    isa => 'ArrayRef',
);

# Let's make this easy for other people and 
# dump the important dbic class methods into
# our object
after BUILD => sub {
    my $self = shift;
    my $args = shift;

    my $meta = $self->dbic_object->meta;
    foreach my $attr ($meta->get_all_methods) {
        next unless $attr->name ~~ $self->db_methods;
        my $name = $attr->name;

        $self->meta->add_method($attr->name => sub {
            shift; #Get rid of self - we don't want it
            my $name = $attr->name;
            $self->dbic_object->$name(@_);
        });
    }

    # Ok, we've added the methods. Let's finish up by
    # using the args originally passed into the constructor and dump
    # them into the object
    foreach my $key (keys %$args) {
        $self->$key($args->{$key});
    }
};

after commit => sub {
    my $self = shift;
    unless ($self->insert_needed) {
        $self->dbic_object->update;
    } else {
        $self->dbic_object->insert;
    }
};

1;
